class Spree::Admin::PageImagesController < Spree::Admin::ResourceController
  
  before_filter :load_data

  create.before :set_viewable
  update.before :set_viewable
  destroy.before :destroy_before

  def update_positions
    params[:positions].each do |id, index|
      Spree::PageImage.update_all(['position=?', index], ['id=?', id])
    end
    respond_to do |format|
      format.js  { render :text => 'Ok' }
    end
  end
  
  private
  
  def location_after_save
    @content_type == "page" ? admin_page_images_url(@resource) : admin_page_content_images_url(@resource.page, @resource)
  end
  

  def load_data

    if params[:content_id]
      @resource = Spree::Content.find(params[:content_id])
      @page = @resource
      @root_parent = @resource.page
      @content_type = "content"
    else
      @resource = Spree::Page.find_by_path(params[:page_id])
      @page = @resource
      @root_parent = @page
      @content_type = "page"
    end
  end

  def set_viewable
    @page_image.viewable = @page
  end

  def destroy_before
    @viewable = @page_image.viewable
  end

end
