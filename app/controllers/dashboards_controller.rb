class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def product_sales
    @sort = params[:sort].presence_in(%w[daily weekly monthly]) || "monthly"
    @filter = params[:product_name].to_s.strip.downcase
    today = Date.current

    @daily_total = total_sales_between(today.beginning_of_day, today.end_of_day)
    @weekly_total = total_sales_between(today.beginning_of_week.beginning_of_day, today.end_of_day)
    @monthly_total = total_sales_between(today.beginning_of_month.beginning_of_day, today.end_of_day)

    @product_sales = compute_product_sales(today)
    @product_sales = filter_product_sales(@product_sales, @filter)
    @product_sales = sort_product_sales(@product_sales, @sort)
  end

  private

  def total_sales_between(start_time, end_time)
    LineItem
      .where(created_at: start_time..end_time)
      .sum("quantity * price")
  end

  def compute_product_sales(today)
    products = Product
               .joins(:line_items) # only products with sales
               .distinct
               .includes(:line_items)

    products.map do |product|
      {
        name: product.name,
        daily: total_for(product, today.beginning_of_day, today.end_of_day),
        weekly: total_for(product, today.beginning_of_week.beginning_of_day, today.end_of_day),
        monthly: total_for(product, today.beginning_of_month.beginning_of_day, today.end_of_day)
      }
    end
  end

  def total_for(product, from, to)
    product.line_items
           .where(created_at: from..to)
           .sum("quantity * price")
           .to_f
  end

  def filter_product_sales(data, keyword)
    return data if keyword.blank?
    data.select { |p| p[:name].downcase.include?(keyword) }
  end

  def sort_product_sales(data, by)
    data.sort_by { |p| -p[by.to_sym] }
  end
end
