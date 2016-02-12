class Api::V1::AuthController < ApplicationController
  skip_before_action :require_login, only: [:request_sms, :verify]
  before_action :skip_authorization

  def request_sms
    phone = params[:user_phone]
    @user = User.find_or_create_by(phone: phone) do |user|
      user_type = params[:user_type]
      if User::PUBLIC_USER_TYPES.include? user_type
        user.type = user_type
      end
    end
    if @user.persisted? && @user.request_sms_code
      head :no_content
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def verify
    phone = params[:user_phone]
    code = params[:user_code]
    @user = User.find_by phone: phone
    if @user && @user.verify_sms_code(code)
      # generate token
      info = {user_agent: request.user_agent}
      auth = @user.authentications.create info: info
      # render token
      response = {
        user_id: @user.id,
        auth_token: AuthToken.encode({ auth_id: auth.id })
      }
      render json: response
    else
      render json: {errors: ['Invalid phone/code or code expired']}, status: :unauthorized
    end
  end

  def revocate_current
    @auth = current_auth_by_token
    @auth.destroy
    head :no_content
  end

  def revocate_other
    @auths = current_user.authentications.where.not(id: current_auth_by_token.id)
    @auths.destroy_all
    head :no_content
  end
end
