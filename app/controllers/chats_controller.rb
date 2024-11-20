class ChatsController < ApplicationController
    before_action :set_chat, only: :show
  
    # GET /chats
    def index
      @chats = Chat.all
    end
  
    # GET /chats/:id
    def show
      @messages = @chat.messages
    end
  
    # POST /chats
    def create
      @chat = Chat.new(chat_params)
  
      if @chat.save
        redirect_to @chat, notice: 'Chat was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_chat
      @chat = Chat.find(params[:id])
    end
  
    def chat_params
      params.require(:chat).permit(:user1_id, :user2_id)
    end
  end