class Admin::CommentsController < ApplicationController
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_post_path(@post.id)
  end

  private

  def comment_params
    params.permit(:comment_content, :post_id)
  end
end
