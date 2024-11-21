class UsersController < ApplicationController
  before_action :require_login

  def index
    @current_user = User.find_by(id: session[:user_id])
    @posts = @current_user.posts
    @meetings = @current_user.meetings
    @chats = Chat.where("user1_id = ? OR user2_id = ?", @current_user.id, @current_user.id)
    @unresponded_chats = @chats.where("last_message_user_id != ?", @current_user.id)
    @newmessages = @unresponded_chats.map do |chat| 
      Message.find(chat.last_message_id)
    end.flatten
  end
  
  def search
    query = params[:query]
    puts query
    if query.length < 2
      @users = User.all[0..10]
      puts @current_user.username
      puts @users.inspect
      @users.reject! { |user| user.username == @current_user.username}
      puts @users.inspect
      
      respond_to do |format|
        format.html # Render a view if needed
        format.json { render json: @users.pluck(:username) } # For dynamic suggestions
      end
    else 
      @users = User.all 
      @users = @users.where("username ILIKE ?", "#{query}%").to_a
      @users.reject! { |user| user.username == @current_user.username}

      puts @users

      respond_to do |format|
        format.html # Render a view if needed
        format.json { render json: @users.pluck(:username) } # For dynamic suggestions
      end
    end
  end
  private 
  def require_login
    unless session[:user_id] != nil
      redirect_to login_path 
    end
    @current_user = User.find_by(id: session[:user_id])
  end
end
