class StarsController < ApplicationController
  before_action :require_login
  
  def create
    @post = Post.find(params[:post_id])
    @current_user.stars.create(post: @post)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: posts_path) }
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @current_user.stars.find_by(post: @post).destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: posts_path) }
    end
  end
end
