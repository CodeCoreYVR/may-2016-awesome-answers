class Api::BaseController < ApplicationController
  before_action :authenticate_api_user
  protect_from_forgery with: :null_session

  private
  
  def authenticate_api_user
    @user = User.find_by_api_key params[:api_key]
    head :forbidden unless @user
  end

end
