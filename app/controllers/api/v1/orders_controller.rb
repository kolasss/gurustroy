class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :cancel, :finish]

  # GET /orders
  # GET /orders.json
  def index
    authorize Order
    if params[:category_ids].present?
      @orders = Order.where(category_id: params[:category_ids])
    else
      @orders = Order.all
    end
    @orders = @orders.includes(:photo)

    # render json: @orders
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    # render json: @order
  end

  # POST /orders
  # POST /orders.json
  def create
    authorize Order
    @order = current_user.orders.new(order_params)

    if @order.save
      render :show, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    if @order.destroy
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def cancel
    if @order.cancel!
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def finish
    if @order.finish! params[:proposal_id]
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
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
