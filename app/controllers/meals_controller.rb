# app/controllers/meals_controller.rb
class MealsController < ApplicationController
  before_action :set_meal, only: %i[update destroy]

  def index
    @meal = Meal.new
    @edit_meal = Meal.find(params[:edit_id]) if params[:edit_id]
    @meals = Meal.order(created_at: :desc).page(params[:page]).per(10)
  end


  def create
    @meal = Meal.new(meal_params)
    if @meal.save
      redirect_to meals_path, notice: "Meal created successfully."
    else
      @meals = Meal.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @meal.update(meal_params)
      redirect_to meals_path, notice: "Meal updated successfully."
    else
      @edit_meal = @meal
      @meals = Meal.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @meal.destroy
    redirect_to meals_path, notice: "Meal deleted successfully."
  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end

  def meal_params
    params.require(:meal).permit(:description, :price)
  end
end
