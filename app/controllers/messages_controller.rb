class MessagesController < ApplicationController
    before_action :set_chat
    before_action :set_message, only: %i[show edit update destroy]
  
    # GET /chats/:chat_id/messages
    def index
      @messages = @chat.messages
    end
  
    # GET /chats/:chat_id/messages/:id
    def show
    end
  
    # GET /chats/:chat_id/messages/new
    def new
      @message = @chat.messages.build
    end
  
    private
  
    def set_chat
      @chat = Chat.find(params[:chat_id])
    end
  
    def set_message
      @message = @chat.messages.find(params[:id])
    end
  
    def message_params
      params.require(:message).permit(:body)
    end
  end