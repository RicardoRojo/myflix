class CategoriesController < ApplicationController
  def show
    @category = Category.includes(:videos).find(params[:id])
  end
end