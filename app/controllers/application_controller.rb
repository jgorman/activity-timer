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
  # Controller and view helpers
  #

  helper_method :seconds_to_hm
  def seconds_to_hm(seconds)
    seconds ||= 0
    hours = seconds / (60 * 60)
    minutes = (seconds / 60) % 60
    sprintf('%2d:%02d', hours, minutes)
  end

  helper_method :show_elapsed
  def show_elapsed(start_time)
    return '' unless start_time
    seconds = Time.now - start_time
    hh = seconds / (60 * 60)
    mm = (seconds / 60) % 60
    ss = seconds % 60
    sprintf('%d:%02d:%02d', hh, mm, ss)
  end

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
