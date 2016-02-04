class ApplicationController < ActionController::API
  include UserAuthentication::Controller
  include Pundit

  before_action :require_login # проверка логина юзера

  after_action :verify_authorized # проверка что применяется пундит

  # если нет прав на действие
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    # нет прав
    def user_not_authorized
      head :forbidden
    end

    # не залогинен
    def user_not_authenticated
      head :unauthorized
    end

    def set_limit_for_query
      params[:limit] || Rails.configuration.query_limit
    end
end
