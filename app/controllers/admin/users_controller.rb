class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @page_title = 'Users'
    @users = User.all
  end

  def show
    @page_title = 'User'
    @user = User.find(params[:id])
  end

  def new
    @page_title = 'New User'
    @user = User.new
  end

  def edit
    @page_title = 'Edit User'
    @user = User.find(params[:id])
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
    params.require(:user).permit(:email, :first_name, :last_name, :roles)
  end
end
