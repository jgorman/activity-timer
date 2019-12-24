class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all.order(:email)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  # https://github.com/plataformatec/devise/wiki/How-To:-Sign-in-as-another-user-if-you-are-an-admin
  # sign_in(:user, User.find(params[:id])) # tracks logins.
  def become
    return unless current_user.is_admin? # TODO: whole controller is_admin?
    bypass_sign_in(User.find(params[:id]))
    flash[:reload_page] = true
    redirect_to timer_path
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to [:admin, @user]
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :role_s)
  end
end
