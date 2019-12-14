module ApplicationHelper
  def escape(str)
    ERB::Util.html_escape(str)
  end

  def page_title
    @page_title || 'Activity Timer'
  end

  def page_header
    @page_header || page_title
  end

  def image_path(name)
    asset_pack_path("media/images/#{name}")
  end

  def is_admin?
    current_user && current_user.is_admin?
  end

  def project_links(project)
    client_link(project.client) + ' - ' + project_link(project)
  end

  def client_link(client)
    link =
      "<a href=\"#{client_path(client)}\">#{escape(client.display_name)}</a>"
    link.html_safe
  end

  def project_link(project)
    link =
      "<a href=\"#{project_path(project)}\" style=\"color:#{project.hex_color}\">#{escape(project.display_name)}</a>"
    link.html_safe
  end

  def input_size(text)
    len = text.length.to_i
    len = 5 if len < 5
    len = 16 if len > 16
    len
  end

  def datetime_to_s(datetime)
    datetime.strftime('%Y-%m-%d %I:%M %p')
  end

  def datetime_to_time_s(datetime)
    datetime.strftime('%I:%M %p')
  end

  def seconds_to_parts(seconds)
    seconds ||= 0
    hh = seconds / (60 * 60)
    mm = (seconds / 60) % 60
    ss = seconds % 60
    [hh, mm, ss]
  end

  def seconds_to_hm(seconds)
    hh, mm = seconds_to_parts(seconds)
    sprintf('%2d:%02d', hh, mm)
  end

  def seconds_to_hms(seconds)
    hh, mm, ss = seconds_to_parts(seconds)
    sprintf('%2d:%02d:%02d', hh, mm, ss)
  end

  def show_elapsed(start_time)
    return '' unless start_time
    seconds = Time.now - start_time
    hh = seconds / (60 * 60)
    mm = (seconds / 60) % 60
    ss = seconds % 60
    sprintf('%d:%02d:%02d', hh, mm, ss)
  end

  module NoArgument; end
  def tr_show(model, field, value = NoArgument)
    case model
    when Symbol
      model_name = model.to_s
    when String
      model_name = model
    else
      model_name = model.class.name.sub(/.*::/, '').underscore
      value = model.send(field.to_sym) if value == NoArgument
    end

    if value == NoArgument
      value = ''
      if model = instance_variable_get("@#{model_name}")
        value = model.send(field.to_sym)
      end
    end

    id = "#{model_name}_#{field}"
    begin
      desc = I18n.translate!("helpers.label.#{model_name}.#{field}")
    rescue StandardError
      desc = field.to_s.titleize
    end
    tr =
      "
<div class=\"row mb-3 mb-sm-auto\">
  <div class=\"col-sm-3 text-label\"><label for=\"#{
        id
      }\">#{escape(desc)}</label></div>
  <div class=\"col\" id=\"#{id}\">#{
        escape(value)
      }</div>
</div>
"
        .html_safe
    tr
  end
end
