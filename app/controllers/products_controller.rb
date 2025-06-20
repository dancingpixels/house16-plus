class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @categories = Category.all
    @selected_category = params[:category_id]
    scope = Product.includes(:category).order(created_at: :desc)
    scope = scope.where(category_id: @selected_category) if @selected_category.present?
    @products = scope.page(params[:page])
    @product = Product.new
    @edit_product = params[:edit_id] ? Product.find_by(id: params[:edit_id]) : nil
  end



  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def update
  #   if @product.update(product_params)
  #     redirect_to product_path(@product), notice: "Product updated."
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # products_controller.rb
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "Product updated."
    else
      @edit_product = @product
      @products = Product.all.includes(:category)
      @categories = Category.all
      render :index, status: :unprocessable_entity
    end
  end


  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :category_id)
  end
end
