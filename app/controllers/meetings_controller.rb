class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :require_user

  def index
    @meetings = Meeting.all.order(start_time: :asc).page(params[:page])
    @meeting = Meeting.new
    @current_user = User.find_by(id: session[:user_id])
  end

  def show
  end

  def new
    @meeting = Meeting.new
  end

  def edit
    @editing_meeting = Meeting.find(params[:id])
    @meetings = Meeting.all
    @current_user = User.find_by(id: session[:user_id])
    @meeting = Meeting.new
    render :index
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @current_user = User.find_by(id: session[:user_id])
    
    @meeting.users << @current_user

    if @meeting.save
      redirect_to meetings_path, notice: 'Meeting was successfully created.'
    else
      flash[:alert] = @meeting.errors.full_messages.join(", ")
      redirect_to meetings_path
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    if @meeting.update(meeting_params)
      redirect_to meetings_path, notice: 'Meeting was successfully updated.'
    else
      @meetings = Meeting.all
      @current_user = User.find_by(id: session[:user_id])
      @editing_meeting = @meeting
      render :index
    end
  end

  def destroy
    @meeting.destroy
    redirect_to meetings_path, notice: 'Meeting was successfully deleted.'
  end

  def join
    @current_user = User.find_by(id: session[:user_id])
    unless @meeting.users.include?(@current_user)
      @meeting.users << @current_user
      redirect_to meetings_path, notice: 'Successfully joined the meeting!'
    else
      redirect_to meetings_path, alert: 'You are already in this meeting'
    end
  end

  def leave
    @current_user = User.find_by(id: session[:user_id])
    if @meeting.users.include?(@current_user)
      @meeting.users.delete(@current_user)
      redirect_to meetings_path, notice: 'Successfully left the meeting'
    else
      redirect_to meetings_path, alert: 'You are not in this meeting'
    end
  end

  private

  def require_user
    unless session[:user_id]
      redirect_to login_path, alert: "You must be logged in to access this page"
    end
  end
  
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :description, :start_time, :end_time)
  end
end
