class SessionsController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def index
    # @session = Session.new
  end

  def show
    @current_user = User.find_by(id: session[:user_id])
  end

  def current_user
    @current_user
  end

  def new
    # renders login form
  end

  def create
    user = User.find_or_create_by(username: params[:username])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  def require_login
    unless session[:user_id] != nil
      redirect_to login_path 
    end
  end

  # private
  #   def session_params
  #     params.require(:session).permit(:username)
  #   end

  
end
