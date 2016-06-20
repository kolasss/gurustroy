class Api::V1::VersionsController < ApplicationController

  def index
    authorize Unit
    @units_version = Unit.version
    @categories_version = Category.version
    render
  end
end
