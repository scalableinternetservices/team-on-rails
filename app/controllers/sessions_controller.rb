class SessionsController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def index
    # @session = Session.new
  end

  def show
    @current_user = User.find_by(id: session[:user_id])
  end

  def current_user
    
  end

  def new
    # renders login form
  end

  def create
    user = User.find_by(username: params[:username])

    if user 
      if user.password == params[:password]
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash.now[:alert] = "Invalid username or password"
        render :new, status: :unprocessable_entity
      end
    else
      user = User.new(username: params[:username], password: params[:password])

      if user.save
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash.now[:alert] = "Could not create new user. Please try again."
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  def require_login
    unless session[:user_id] != nil
      redirect_to login_path 
    end
    @current_user = User.find_by(id: session[:user_id])
  end

end
