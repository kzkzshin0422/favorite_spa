class Admin::PostsController < ApplicationController
  
  before_action :authenticate_admin!
  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post = Post.find(params[:id])
       @post.update(post_params)
       redirect_to admin_post_path(@post.id)
    else
       render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end
  
  private
  
  def post_params
    params.require(:post).permit(:facility_name, :service, :address)
  end
end
