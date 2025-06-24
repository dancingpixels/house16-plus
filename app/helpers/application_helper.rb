module ApplicationHelper
  def formatted_amount(number)
    ('%.2f' % number.to_f).reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end

