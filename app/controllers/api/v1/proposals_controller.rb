class Api::V1::ProposalsController < ApplicationController
  before_action :set_proposal, only: [:show, :update, :destroy, :cancel]
  before_action :set_order, only: [:index, :create]

  # GET /orders/1/proposals
  # GET /orders/1/proposals.json
  def index
    authorize @order
    @proposals = @order.proposals.all.includes(:photo)
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
  end

  # POST /orders/1/proposals
  # POST /orders/1/proposals.json
  def create
    authorize Proposal
    @proposal = current_user.proposals.new(proposal_params)
    @proposal.order = @order

    if @proposal.save
      render :show, status: :created
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /proposals/1
  # PATCH/PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])

    if @proposal.update(proposal_params)
      head :no_content
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    if @proposal.destroy
      head :no_content
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  def cancel
    if @proposal.deleted!
      head :no_content
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  private

    def set_proposal
      @proposal = Proposal.find(params[:id])
      authorize @proposal
    end

    def set_order
      @order = Order.find(params[:order_id])
    end

    def proposal_params
      params.require(:proposal).permit(
        :description,
        :price,
        photo_attributes: [:id, :file, :_destroy]
      )
    end
end
