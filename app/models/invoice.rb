class Invoice < ApplicationRecord
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true

  after_save :deduct_stock

  private

  def deduct_stock
    line_items.each do |item|
      product = item.product
      product.update!(quantity: product.quantity - item.quantity)
    end
  end
end
