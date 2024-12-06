class StarsController < ApplicationController
  before_action :require_login
  before_action :set_post
  
  def create
    @current_user.stars.create(post: @post)
    redirect_back(fallback_location: posts_path)
  end

  def destroy
    star = @current_user.stars.find_by(post: @post)
    star&.destroy # Using safe navigation operator
    redirect_back(fallback_location: posts_path)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
