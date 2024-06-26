class Public::PostsController < ApplicationController

  before_action :authenticate_user!, except: [:top]

  def new
    @post = Post.new
  end

  def index
    @posts = Post.where(is_draft: false).order(params[:sort])
  end

  def show
    @post = Post.find_by(id: params[:id])
     if @post
      @tags = @post.tags.pluck(:name).join(',')
      @comments = @post.comments
      if @post.is_draft == true
       redirect_to posts_path
      end
     else
      redirect_to root_path
     end
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user == current_user
      render "edit"
    else
      redirect_to posts_path
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    @tags = params[:post][:tag_name].split(',')
    if @post.save
     @post.save_tags(@tags)
     redirect_to post_path(@post.id),success: t('posts.create.create_success')
    else
     render :new
    end
  end
  
  def draft_index
    @user = current_user
    @posts = @user.posts.where(is_draft: true).order('created_at DESC')
  end
  

  def update
    @post = Post.find(params[:id])
    tags = params[:post][:tag_name].split(',')
    if @post.update(post_params)
      @post.update_tags(tags)
      redirect_to post_path(@post.id),success: t('posts.edit.edit_success')
    else
       render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    if post.user == current_user
      @posts = Post.where(is_draft: false)
      render "index"
    else
      redirect_to edit_post_path(post.id)
    end
  end

  def search
    #Viewのformで取得したパラメータをモデルに渡す
    @keyword = params[:post][:search] if params[:post]
    @posts_all = Tag.search(@keyword)
  end

  private

  def post_params
    params.require(:post).permit(:facility_name, :service, :address, :star, :comment, :is_draft)
  end

end
