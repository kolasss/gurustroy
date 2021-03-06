class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    authorize Category
    @categories_version = Category.version
    if params[:q].present?
      @categories = Category.find_by_tag_name params[:q]
    else
      @categories = Category.all
    end
    render
  end

  # POST /categories
  # POST /categories.json
  def create
    authorize Category
    @category = Category.new(category_params)

    if @category.save
      render status: :created
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      render :create, status: :ok
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    if @category.destroy
      head :no_content
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
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
