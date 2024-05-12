class Admin::UsersController < ApplicationController

  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to admin_user_path(user.id)
  end

  def confirm

    @user = User.find(params[:user_id])
  end

  def withdrawal
    user = User.find(params[:user_id])
    user.update(is_active: false)
    reset_session
    user.posts.destroy_all
    user.comments.destroy_all
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:profile, :nickname, :first_name, :last_name, :email)
  end
end
