class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :with_timezone

  def oops_page
    if flash[:notice]
      redirect_to '/user_session/oops', notice: flash[:notice]
    else
      redirect_to '/user_session/oops'
    end
    return false
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :current_password)
    end
  end

  def with_timezone
    timezone = Time.find_zone(cookies[:timezone])
    Time.use_zone(timezone) { yield }
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
