class ChatsController < ApplicationController
    before_action :set_chat, only: [:show, :create_message]
    before_action :require_login
  
    def show
        check_authorization()
        @chat_recipient_id = @chat.user1_id == @current_user.id ? @chat.user2_id : @chat.user1_id
        @chat_recipient = User.find(@chat_recipient_id)

        puts @chat_recipient.username
        @messages = @chat.messages.order(created_at: :asc)
        @message = Message.new 
    end

    def new
        @chat = Chat.new
    end

    def create
        otherUser = User.find_by(username: params[:query])
        if otherUser.nil?
            redirect_back(fallback_location:posts_path, alert: 'User not found')
        elsif otherUser.id == @current_user.id
            puts chats_path
            redirect_back(fallback_location:posts_path, alert: 'You cannot chat with yourself')
        else
            @chat = Chat.new(:user1_id => @current_user.id, :user2_id => otherUser.id)
            if @chat.save
                redirect_to @chat
            else
                redirect_back(fallback_location: posts_path, alert: 'There was an error creating the chat.')
            end
        end
    end
  
    def create_message
      @message = @chat.messages.new(message_params)
      @message.user_id = @current_user.id
      @message.chat_id = @chat.id

      if @message.save
        @chat.update(last_message_id: @message.id, last_message_user_id: @current_user.id)
        redirect_to @chat, notice: 'Message sent successfully.'
      else
        render :show, alert: 'Message could not be sent.'
      end
    end
  
    private

    def require_login
        unless session[:user_id] != nil
          redirect_to login_path 
        end
        @current_user = User.find_by(id: session[:user_id])
    end
    # Callback methods
    def set_chat
        @chat = Chat.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to chats_path, alert: 'Chat not found'
    end

    def check_authorization
        unless @chat.user1_id == @current_user.id || @chat.user2_id == @current_user.id
            puts @chat.user1_id
            puts @chat.user2_id

            redirect_to posts_path, alert: 'You are not authorized to view this chat.'
        end
    end

    def set_participants
        @user1 = @chat.user1
        @user2 = @chat.user2
    end

    def message_params
        params.require(:message).permit(:body)
    end

    def chat_params
        params.require(:chat).permit(:query)  # Adjust to your Chat model's attributes
     end
end
