class Api::V1::MessagesController < ApplicationController
  before_action :identify_user
  before_action :find_chat
  before_action :find_message, only: [:update]

  # GET /api/v1/applications/:application_token/chats/:chat_number/messages
  def index
    result = MessageServices::AllMessagesGetter.new(@chat).get_all_messages

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end

    render json: {
      success: true,
      result: MessageSerializer.serialize(result[:data])
    }
  end

  # GET /api/v1/applications/:application_token/chats/:chat_number/messages/:number
  def show
    result = MessageServices::MessageGetter.new(@application, @chat, params[:number]).get_message

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end
    
    render json: {
      success: true,
      result: MessageSerializer.serialize(result[:data])
    }

  end

  # POST /api/v1/applications/:application_token/chats/:chat_number/messages
  def create
    result = MessageServices::MessageCreator.new(@application, @chat, params[:content]).create_message

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end
    
    render json: {
      success: true,
      result: MessageSerializer.serialize(result[:data])
    }
  end

  # PATCH/PUT /api/v1/applications/:application_token/chats/:chat_number/messages/:number
  def update 
    result = MessageServices::MessageUpdater.new(@application, @chat, @message, params[:content]).update_message

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end

    render json: {
      success: true,
      result: MessageSerializer.serialize(result[:data])
      
    }
  end

  #GET /api/v1/applications/:application_token/chats/:number/search?query=loremipsum
  def search
    result = MessageServices::SearchService.new(@chat, params[:query]).search

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end

    render json: {
      success: true,
      result: MessageSerializer.serialize(result[:data])
    }
  end



  private
  
  # fetches message
  def find_message
    @message = Message.find_by(chat_id: @chat.id, number: params[:number])
    if !@message then
      render json: {
        success: false,
        message: 'Message not found'
      }
    end
  end

    # fetches chat
    def find_chat
      @chat = @application.chats.find_by(number: params[:chat_number])
      if !@chat then
        render json: {
          success: false,
          message: 'Chat not found'
        }
      end
    end
  
    # fetches application and identifies the user
    def identify_user
      @application = params[:application_token].present? && Application.find_by(token: params[:application_token])
      if !@application then
        render json: {
          success: false,
          message: 'Identification failed!'
        }
      end
    end
      
end
