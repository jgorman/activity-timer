# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def alert; end

  def guest
    if guest_user = User.find_by_email(GuestHistory::Defaults[:guest][:email])
      bypass_sign_in(guest_user)
      flash[:reload_page] = true
      redirect_to timer_path
    else
      alert_page("No guest user available now. Sorry.")
    end
  end
end
