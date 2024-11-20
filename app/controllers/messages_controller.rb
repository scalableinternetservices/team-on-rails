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
  
    # POST /chats/:chat_id/messages
    def create
      @message = @chat.messages.build(message_params.merge(user: current_user))
  
      if @message.save
        redirect_to chat_messages_path(@chat), notice: 'Message was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    # GET /chats/:chat_id/messages/:id/edit
    def edit
    end
  
    # PATCH/PUT /chats/:chat_id/messages/:id
    def update
      if @message.update(message_params)
        redirect_to chat_messages_path(@chat), notice: 'Message was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    # DELETE /chats/:chat_id/messages/:id
    def destroy
      @message.destroy
      redirect_to chat_messages_path(@chat), notice: 'Message was successfully deleted.'
    end
  
    private
  
    def set_chat
      @chat = Chat.find(params[:chat_id])
    end
  
    def set_message
      @message = @chat.messages.find(params[:id])
    end
  
    def message_params
      params.require(:message).permit(:content)
    end
  end