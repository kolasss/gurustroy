class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :orders, :proposals]

  # GET /users
  # GET /users.json
  def index
    authorize User
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    authorize User
    @user = User.new(user_params)

    if @user.save
      render :show, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    # TODO сделать смену типа через модель

    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.destroy
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def orders
    @orders = @user.orders.includes(:photo)
  end

  def proposals
    @proposals = @user.proposals.includes(:photo)
  end

  private

    def set_user
      @user = User.find(params[:id])
      authorize @user
    end

    def user_params
      params.require(:user).permit(
        :phone,
        :name,
        :company,
        :type
      )
    end
end
