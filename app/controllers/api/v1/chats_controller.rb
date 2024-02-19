class Api::V1::ChatsController < ApplicationController
  before_action :identify_user

  # GET /api/v1/applications/:application_token/chats
  def index
    
    result = ChatServices::AllChatsGetter.new(@application).get_all_chats
    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end

    render json: {
      success: true,
      result: ChatSerializer.serialize(result[:data])
    }
  end

  # GET /api/v1/applications/:application_token/chats/:number
  def show
    result = ChatServices::ChatGetter.new(@application, params[:number]).get_chat
    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end
    
    render json: {
      success: true,
      result: ChatSerializer.serialize(result[:data])
    }

  end

  # POST /api/v1/applications/:application_token/chats
  def create
    result = ChatServices::ChatCreator.new(@application).create_chat
    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end
    
    render json: {
      success: true,
      result: ChatSerializer.serialize(result[:data])
    }
  end



  private

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
