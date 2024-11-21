class UsersController < ApplicationController
  before_action :set_current_user
  
  def index
    @meetings = @current_user.meetings
    @posts = @current_user.posts.order(created_at: :desc)
  end

  def update_role
    @current_user.update(role: params[:role])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('role-selector', 
        partial: 'users/role_selector', locals: { user: @current_user }) }
    end
  end

  private

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end
end
