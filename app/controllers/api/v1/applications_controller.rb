class Api::V1::ApplicationsController < ApplicationController
  before_action :identify_user, only: [:update]

  # GET /applications or /applications.json
  def index
    result = ApplicationServices::AllApplicationsGetter.new().get_applications

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end
     
    render json: {
      success: true,
      result: ApplicationSerializer.serialize(result[:data])
    }
  end

  # GET /api/v1/applications/:token
  def show
    result = ApplicationServices::ApplicationGetter.new(params[:token]).get_app

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end
     
    render json: {
      success: true,
      result: ApplicationSerializer.serialize(result[:data])
    }
  end

  # POST /api/v1/applications
  def create
    result = ApplicationServices::ApplicationCreator.new(name: params[:name]).create_app

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end

    render json: {
      success: true,
      result: ApplicationSerializer.serialize(result[:data])
    }
  end

  # PATCH/PUT /api/v1/applications/:token
  def update 
    result = ApplicationServices::ApplicationUpdater.new(@application, params[:name]).update_app

    if !result[:success] then
      return render json: {
        success: false,
        message: result[:message]
      } 
    end

    render json: {
      success: true,
      result: {
        data:  ApplicationSerializer.serialize(result[:data])
      }
    }
  end


  private

    # fetches application and identifies the user
    def identify_user
      @application = params[:token].present? && Application.find_by(token: params[:token])
      if !@application then
        render json: {
          success: false,
          message: 'Identification failed!'
        }
      end
    end
  
end
