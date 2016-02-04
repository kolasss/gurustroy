class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    skip_authorization
    render json: {message: 'Visit http://docs.gurustroy.apiary.io/ for API documentation'}
  end
end
