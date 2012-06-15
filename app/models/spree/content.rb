class Spree::Content < ActiveRecord::Base

  attr_accessor :delete_attachment
  attr_accessible :page_id, :title, :path, :body, :hide_title, :link, :link_text, :context, :attachment, :delete_attachment

  belongs_to :page
  validates_associated :page
  validates_presence_of :title, :page

  # has_attached_file :attachment,
  #   :styles        => Proc.new{ |clip| clip.instance.attachment_sizes },
  #   :default_style => :preview,
  #   :url           => "/spree/contents/:id/:style/:basename.:extension",
  #   :path          => ":rails_root/public/spree/contents/:id/:style/:basename.:extension"
  #   
  # if Spree::Config[:use_s3]
  #   s3_creds = { :access_key_id => Spree::Config[:s3_access_key], :secret_access_key => Spree::Config[:s3_secret], :bucket => Spree::Config[:s3_bucket] }
  #   Spree::PageImage.attachment_definitions[:attachment][:storage] = :s3
  #   Spree::PageImage.attachment_definitions[:attachment][:s3_credentials] = s3_creds
  #   Spree::PageImage.attachment_definitions[:attachment][:s3_headers] = ActiveSupport::JSON.decode(Spree::Config[:s3_headers])
  #   Spree::PageImage.attachment_definitions[:attachment][:bucket] = Spree::Config[:s3_bucket]
  # end

  
  cattr_reader :per_page
  @@per_page = 10

  scope :for, Proc.new{|context| where(:context => context)}

  before_update :delete_attachment!, :if => :delete_attachment
  before_update :reprocess_images_if_context_changed
  
  # has_many :images, :as => :viewable, :class_name => "Spree::PageImage", :order => :position, :dependent => :destroy
  has_many :images, :as => :viewable, :order => :position, :dependent => :destroy

  [ :link_text, :link, :body ].each do |property|
    define_method "has_#{property.to_s}?" do
      has_value property
    end
  end

  def has_full_link?
    has_link? && has_link_text?
  end

  def has_image?
    has_value(:attachment_file_name) && attachment_file_name.match(/gif|jpg|png/i)
  end

  def hide_title?
    self.hide_title == true
  end

  def rendered_body
    RDiscount.new(body.to_s).to_html.html_safe
  end

  def default_attachment_sizes
    { :mini => '48x48>', :medium => '427x287>' }
  end

  def attachment_sizes
    case self.context
      when 'slideshow'
        sizes = default_attachment_sizes.merge(:slide => '955x476#')
      else
        sizes = default_attachment_sizes
    end
    sizes
  end

  def context=(value)
    write_attribute :context, value.to_s.parameterize
  end

private

  def delete_attachment!
    del = delete_attachment.to_s
    self.attachment = nil if del == "1" || del == "true"
    true
  end

  def reprocess_images_if_context_changed
    return unless context_changed? && attachment_file_name.present?
    attachment.reprocess!
  end

  def has_value(selector)
    v = self.send selector
    v && !v.to_s.blank?
  end

end
