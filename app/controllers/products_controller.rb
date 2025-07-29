class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :load_categories, only: [:index, :create, :update]
  before_action :set_product, only: [:update, :destroy]

  def index
    @selected_category = params[:category_id]
    scope = Product.includes(:category).order(created_at: :desc)
    scope = scope.where(category_id: @selected_category) if @selected_category.present?
    @products = scope.page(params[:page])
    @product = Product.new
    @edit_product = params[:edit_id] ? Product.find_by(id: params[:edit_id]) : nil
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to products_path, notice: "Product was successfully created."
    else
      @products = Product.includes(:category).order(created_at: :desc).page(params[:page]) # ✅ Consistent
      @edit_product = nil
      render :index, status: :unprocessable_entity
    end
  end

  def edit
     @product = Product.find(params[:id])
     @categories = Category.all
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product updated."
    else
      @edit_product = @product
      @products = Product.includes(:category).order(created_at: :desc).page(params[:page])
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted."
  end

  private

  def load_categories
    @categories = Category.all
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :category_id)
  end
end
