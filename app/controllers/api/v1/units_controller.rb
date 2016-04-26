class Api::V1::UnitsController < ApplicationController
  before_action :set_unit, only: [:update, :destroy]

  # GET /units
  # GET /units.json
  def index
    authorize Unit
    @units_version = Unit.version
    @units = Unit.all
  end

  # POST /units
  # POST /units.json
  def create
    authorize Unit
    @unit = Unit.new(unit_params)

    if @unit.save
      render status: :created
    else
      render json: {errors: @unit.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    @unit = Unit.find(params[:id])

    if @unit.update(unit_params)
      render :create, status: :ok
    else
      render json: {errors: @unit.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    if @unit.destroy
      head :no_content
    else
      render json: {errors: @unit.errors}, status: :unprocessable_entity
    end
  end

  private

    def set_unit
      @unit = Unit.find(params[:id])
      authorize @unit
    end

    def unit_params
      params.require(:unit).permit(:name)
    end
end
