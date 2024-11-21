class UsersController < ApplicationController
  def index
    @current_user = User.find_by(id: session[:user_id])
    @posts = @current_user.posts
    @meetings = @current_user.meetings
  end
end
