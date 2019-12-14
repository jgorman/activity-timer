class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :with_timezone

  # TODO: security check violatons will go here.
  def oops_page
    if flash[:notice]
      redirect_to '/user_session/oops', notice: flash[:notice]
    else
      redirect_to '/user_session/oops'
    end
    return false
  end

  private

  def after_sign_in_path_for(user)
    timer_path
  end

  # Extra fields for Devise Users.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :current_password)
    end
  end

  #####
  # Use the browser timezone hoisted up from a cookie.
  #
  # http://thisbythem.com/blog/clientside-timezone-detection/
  # https://www.npmjs.com/package/jstimezonedetect
  # https://github.com/js-cookie/js-cookie
  #
  # See app/javascript/javascript/timezonedetect.js
  def with_timezone
    timezone = Time.find_zone(cookies[:timezone])
    Time.use_zone(timezone) { yield }
  end

  #####
  # Controller and view helpers.
  #
  # To use ApplicationHelpers in controllers:
  #   helpers.seconds_to_hm(length)
  #
  # To use controller helpers in views:
  #   helper_method :menu_label_for
  #   def menu_label_for(tag)
  #     label, title = t(tag)
  #   end

  def hm_to_seconds(hhmm)
    hhmm ||= ''
    if hhmm.include?(':')
      hh, mm = hhmm.split(':')
    else
      hh, mm = 0, hhmm
    end
    ((hh.to_i * 60) + mm.to_i) * 60
  end
end
