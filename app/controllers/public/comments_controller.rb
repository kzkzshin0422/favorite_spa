class Public::CommentsController < ApplicationController
  
  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private

  def comment_params
    params.permit(:comment_content, :post_id)
  end
end
