class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :cancel, :finish]

  # GET /orders
  # GET /orders.json
  def index
    authorize Order
    limit = set_limit_for_query
    @orders = Order.by_created.includes(:photo).limit(limit)
    @orders = @orders.offset(params[:offset]) if params[:offset].present?
    @orders = @orders.where(category_id: params[:category_ids]) if params[:category_ids].present?
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # POST /orders
  # POST /orders.json
  def create
    authorize Order
    @order = current_user.orders.new(order_params)

    if @order.save
      render :show, status: :created
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      head :no_content
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    if @order.destroy
      head :no_content
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  def cancel
    if @order.cancel!
      head :no_content
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  def finish
    if @order.finish! params[:proposal_id]
      head :no_content
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
      authorize @order
    end

    def order_params
      params.require(:order).permit(
        :description,
        :quantity,
        :unit_id,
        :price,
        :category_id,
        photo_attributes: [:id, :file, :_destroy]
      )
    end
end
