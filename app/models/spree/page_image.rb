class Spree::PageImage < Spree::Asset

  attr_accessible :viewable, :attachment, :alt

  validates_attachment_presence :attachment
  
  has_attached_file :attachment,
    # :styles => Proc.new{ |clip| clip.instance.attachment_sizes },
    :styles => { :mini => '48x48>', :medium => '427x287>', :hero => '720x430#', :hub_thumb => "95x65#", :hub_info => "245x180#" },
    :default_style => :medium,
    :url => '/spree/pages/:id/:style/:basename.:extension',
    :path => ':rails_root/public/spree/pages/:id/:style/:basename.:extension'

  def image_content?
    attachment_content_type.to_s.match(/\/(jpeg|png|gif|tiff|x-photoshop)/)
  end

  def attachment_sizes
    sizes = { :mini => '48x48>', :medium => '427x287>', :hero => '720x430#', :hub_thumb => "95x65#", :hub_info => "245x180#" }
    if image_content?
      sizes.merge!(:mini => '48x48>', :small => '150x150>', :medium => '420x300>', :large => '900x650>')
      sizes.merge!(:slide => '950x250#') if viewable.respond_to?(:root?) && viewable.root?
    end
    sizes
  end

end


# Image.attachment_definitions[:attachment][:styles].merge!(
#   :mini => '48x48>', :medium => '427x287>', :hero => '720x430#', :hub_thumb => "95x65#", :hub_info => "245x180#"
# )