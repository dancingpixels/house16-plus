class KitchenController < ApplicationController
  def index
    daily   = Meal.where(created_at: Time.zone.today.all_day)
    weekly  = Meal.where(created_at: Time.zone.now.all_week)
    monthly = Meal.where(created_at: Time.zone.now.all_month)

    @stats = {
      daily: stats_for(daily),
      weekly: stats_for(weekly),
      monthly: stats_for(monthly)
    }
  end

  private

  def stats_for(meals)
    {
      total_count: meals.count,
      total_price: meals.sum(:price)
    }
  end
end
