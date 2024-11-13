class PostsController < ApplicationController
  before_action :require_login

  def index
    @posts = Post.all
    @current_user = User.find_by(id: session[:user_id])
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

  def create
    @current_user = User.find_by(id: session[:user_id]) # find user

    @post = @current_user.posts.build(post_params) # create post
    @post.username = @current_user.username
    @post.user_id = @current_user.id  # build automatically adds id?
    @post.num_comments = 0  # TODO: update this to actual # of comments

    # puts "Post contents: #{@post.inspect}"
    if @post.save
      redirect_to root_path
      puts "Post created successfully"
    else
      # render :new, status: :unprocessable_entity # Return error
      flash[:alert] = @post.errors.full_messages.join(", ")
      redirect_to root_path
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params) 
      redirect_to post_path 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
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

end

