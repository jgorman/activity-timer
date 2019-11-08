module ApplicationHelper
  def escape(str)
    ERB::Util.html_escape(str)
  end

  def page_title
    @page_title || 'Activity Timer'
  end

  def image_path(name)
    asset_pack_path("media/images/#{name}")
  end
end
