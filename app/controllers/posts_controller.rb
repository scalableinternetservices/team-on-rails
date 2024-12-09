class PostsController < ApplicationController
  before_action :require_login
  before_action :set_current_user
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @current_user = User.find_by(id: session[:user_id])
    
    @posts = case params[:filter]
             when 'instructor'
               Post.joins(:user).where(users: { role: 'instructor' }).order('posts.created_at DESC').page(params[:page])
             when 'student'
               Post.joins(:user).where(users: { role: 'student' }).order('posts.created_at DESC').page(params[:page])
             else
               Post.order('created_at DESC').all.page(params[:page])
             end
    
    @chats = Chat.where("user1_id = ? OR user2_id = ?", @current_user.id, @current_user.id)
    @unresponded_chats = @chats.where("last_message_user_id != ?", @current_user.id)
    @newmessages = @unresponded_chats.map do |chat| 
      Message.find(chat.last_message_id)
    end.flatten
    @lastpost= Post.last
  end

  def show
    @current_user = User.find_by(id: session[:user_id])
    begin
      @post = Post.find(params[:id])
      @comments = @post.comments

    # Returns 404 if post not found
    rescue ActiveRecord::RecordNotFound
      @post = nil
      render file: "#{Rails.root}/public/404.html", status: :not_found unless @post
      return
    end
  end

  def new
    @post = Post.new
  end

  def edit
    unless can_manage_post?(@post)
      flash[:alert] = "You don't have permission to edit this post"
      redirect_to posts_path
      return
    end
  end

  def create
    @current_user = User.find_by(id: session[:user_id]) # find user

    @post = @current_user.posts.build(post_params) # create post
    @post.username = @current_user.username
    @post.user_id = @current_user.id  # build automatically adds id?
    @post.num_comments = 0  # TODO: update this to actual # of comments

    # puts "Post contents: #{@post.inspect}"
    if @post.save
      redirect_to post_path(@post)
      puts "Post created successfully"
    else
      # render :new, status: :unprocessable_entity # Return error
      flash[:alert] = @post.errors.full_messages.join(", ")
      redirect_to root_path
    end
  end

  def update
    unless can_manage_post?(@post)
      flash[:alert] = "You don't have permission to edit this post"
      redirect_to posts_path
      return
    end

    if @post.update(post_params) 
      redirect_to post_path 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.nil?
      redirect_to posts_path, alert: "Post not found."
      return
    end
    unless can_manage_post?(@post)
      flash[:alert] = "You don't have permission to delete this post"
      redirect_to posts_path
      return
    end
    if @post
      @post.destroy
      redirect_to posts_path, notice: "Post was successfully deleted."
    else
      redirect_to posts_path, alert: "Post not found."
    end
  end
  

  private
    def require_login
      unless session[:user_id] != nil
        redirect_to login_path 
      end
    end

    def post_params
      params.require(:post).permit(:body, :username, :num_comments, :user_id)
    end

    def set_current_user
      @current_user = User.find_by(id: session[:user_id])
      unless @current_user
        redirect_to login_path
        return
      end
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end

    def can_manage_post?(post)
      return false unless @current_user
      @current_user.instructor? || @current_user.username == post.username
    end

end

