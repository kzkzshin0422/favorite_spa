class Public::UsersController < ApplicationController

  before_action :authenticate_user!, except: [:top]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.where(is_active:true).where.not(id: current_user.id)
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(is_draft: :true).order("created_at DESC")
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def confirm
  end

  def withdrawal
    user = current_user
    user.update(is_active: false)
    reset_session
    user.posts.destroy_all
    user.comments.destroy_all
    redirect_to root_path
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile_image, :nickname, :profile)
  end
end
