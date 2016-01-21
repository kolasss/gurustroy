class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: [:update, :destroy]
  before_action :set_category, only: [:index, :create]

  # GET /tags
  # GET /tags.json
  def index
    authorize Tag
    @tags = @category.tags.all
  end

  # POST /tags
  # POST /tags.json
  def create
    authorize Tag
    @tag = @category.tags.new(tag_params)

    if @tag.save
      render status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      head :no_content
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    if @tag.destroy
      head :no_content
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
      authorize @tag
    end

    def set_category
      @category = Category.find(params[:category_id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end
end
