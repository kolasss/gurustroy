class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    if params[:q].present?
      @categories = Category.find_by_tag_name params[:q]
    else
      @categories = Category.all
    end
    authorize @categories

    render json: @categories
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    authorize @category

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      head :no_content
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy

    head :no_content
  end

  private

    def set_category
      @category = Category.find(params[:id])
      authorize @category
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
