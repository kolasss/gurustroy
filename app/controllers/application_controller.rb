class ApplicationController < ActionController::API
  include UserAuthentication
  # include Pundit

  before_action :require_login # проверка логина юзера

  # after_action :verify_authorized

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    # нет прав
    def user_not_authorized
      head :forbidden
    end

    # не залогинен
    def user_not_authenticated
      head :unauthorized
    end
end
