class Spree::PageImage < Spree::Image
  has_attached_file :attachment,
                    :styles => { :mini => '48x48>', :medium => '427x287>', :hero => '720x430#', :hub_thumb => "95x65#", :hub_info => "245x180#" },
                    :default_style => :medium,
                    :url => '/spree/pages/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/pages/:id/:style/:basename.:extension'
    
    if Spree::Config[:use_s3]
      s3_creds = { :access_key_id => Spree::Config[:s3_access_key], :secret_access_key => Spree::Config[:s3_secret], :bucket => Spree::Config[:s3_bucket] }
      Spree::PageImage.attachment_definitions[:attachment][:storage] = :s3
      Spree::PageImage.attachment_definitions[:attachment][:s3_credentials] = s3_creds
      Spree::PageImage.attachment_definitions[:attachment][:s3_headers] = ActiveSupport::JSON.decode(Spree::Config[:s3_headers])
      Spree::PageImage.attachment_definitions[:attachment][:bucket] = Spree::Config[:s3_bucket]
    end
  # 
  # 
  # def image_content?
  #   attachment_content_type.to_s.match(/\/(jpeg|png|gif|tiff|x-photoshop)/)
  # end
  # 
  # def attachment_sizes
  #   sizes = { :mini => '48x48>', :medium => '427x287>', :hero => '720x430#', :hub_thumb => "95x65#", :hub_info => "245x180#" }
  #   if image_content?
  #     sizes.merge!(:mini => '48x48>', :small => '150x150>', :medium => '420x300>', :large => '900x650>')
  #     sizes.merge!(:slide => '950x250#') if viewable.respond_to?(:root?) && viewable.root?
  #   end
  #   sizes
  # end

end


# Image.attachment_definitions[:attachment][:styles].merge!(
#   :mini => '48x48>', :medium => '427x287>', :hero => '720x430#', :hub_thumb => "95x65#", :hub_info => "245x180#"
# )