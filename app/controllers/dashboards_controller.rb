# class DashboardsController < ApplicationController
#   def product_sales
#     today = Date.current
#     start_of_week = today.beginning_of_week
#     start_of_month = today.beginning_of_month

#     @daily_total = total_sales_between(today.beginning_of_day, today.end_of_day)
#     @weekly_total = total_sales_between(start_of_week.beginning_of_day, today.end_of_day)
#     @monthly_total = total_sales_between(start_of_month.beginning_of_day, today.end_of_day)
#   end

#   private

#   def total_sales_between(start_time, end_time)
#     LineItem
#       .where(created_at: start_time..end_time)
#       .sum("quantity * price")
#   end
# end

class DashboardsController < ApplicationController
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
    products = Product.includes(:line_items).all

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
