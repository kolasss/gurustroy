class Api::V1::UsersController < ApplicationController
  before_action :set_user, except: [:index, :create, :change_my_type]

  # GET /users
  # GET /users.json
  def index
    authorize User
    limit = set_limit_for_query
    @users = User.by_created.limit(limit)
    @users = @users.offset(params[:offset]) if params[:offset].present?
    render
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render
  end

  # POST /users
  # POST /users.json
  def create
    authorize User
    @user = User.new(create_user_params)

    if @user.save
      render :show, status: :created
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(update_user_params)
      render :show, status: :ok
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.destroy
      head :no_content
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # GET /users/1/orders
  def orders
    limit = set_limit_for_query
    @orders = @user.orders.by_created.includes(:photo).limit(limit)
    @orders = @orders.offset(params[:offset]) if params[:offset].present?
    render
  end

  # GET /users/1/proposals
  def proposals
    limit = set_limit_for_query
    @proposals = @user.proposals.by_created.includes(:photo).limit(limit)
    @proposals = @proposals.offset(params[:offset]) if params[:offset].present?
    render
  end

  # PUT /users/1/change_type
  def change_type
    @user = @user.change_type params[:user_type]

    if @user.errors.empty?
      render :show, status: :ok
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # PUT /users/change_my_type
  def change_my_type
    authorize User
    user_type = params[:user_type]
    if User::PUBLIC_USER_TYPES.include? user_type
      @user = current_user.change_type params[:user_type]

      if @user.errors.empty?
        render :show, status: :ok
      else
        render json: {errors: @user.errors}, status: :unprocessable_entity
      end
    else
      render json: {errors: "Invalid user's type"}, status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
      authorize @user
    end

    def create_user_params
      params.require(:user).permit(
        :phone,
        :name,
        :company,
        :type
      )
    end

    def update_user_params
      params.require(:user).permit(
        :phone,
        :name,
        :company
      )
    end
end
