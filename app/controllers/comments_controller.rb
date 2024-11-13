class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build
  end

  def create
    @current_post = Post.find_by(id: params[:post_id])
    @comment = @current_post.comments.build(comment_params)

    if @comment.save
      redirect_to post_path(@current_post)
    else
      flash[:error] = "Error creating comment"
      flash[:alert] = @comment.errors.full_messages.join(", ")
      redirect_to post_path(@current_post)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
