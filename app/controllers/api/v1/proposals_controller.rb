class Api::V1::ProposalsController < ApplicationController
  before_action :set_proposal, only: [:show, :update, :destroy]

  # GET /proposals
  # GET /proposals.json
  def index
    @proposals = Proposal.all

    render json: @proposals
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    render json: @proposal
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(proposal_params)

    if @proposal.save
      render json: @proposal, status: :created, location: @proposal
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
    @proposal.destroy

    head :no_content
  end

  private

    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    def proposal_params
      params.require(:proposal).permit(:order_id, :description, :price, :status, :user_id)
    end
end
