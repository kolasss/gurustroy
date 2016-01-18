class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :orders, :proposals]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    authorize @users

    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

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
    @orders = @user.orders

    render json: @orders
  end

  def proposals
    @proposals = @user.proposals

    render json: @proposals
  end

  private

    def set_user
      @user = User.find(params[:id])
      authorize @user
    end

    def user_params
      params.require(:user).permit(:phone, :name, :company, :type)
    end
end
