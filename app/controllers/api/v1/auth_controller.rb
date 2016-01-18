class Api::V1::AuthController < ApplicationController
  skip_before_action :require_login
  before_action :skip_authorization

  def request_sms
    phone = params[:user][:phone]
    @user = User.find_or_create_by(phone: phone) do |user|
      user_type = params[:user][:type]
      if User::PUBLIC_USER_TYPES.include? user_type
        user.type = user_type
      end
    end
    @user.generate_sms_code
    @user.send_sms_code
    head :ok
  end

  def verify
    phone = params[:user][:phone]
    code = params[:user][:code]
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
      render json: { errors: ['Invalid phone/code or code expired'] }, status: :unauthorized
    end
  end
end
