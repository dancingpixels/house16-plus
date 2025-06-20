class LineItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate :available_stock

  before_validation :set_price

  private

  def set_price
    self.price ||= product&.price
  end

  def available_stock
    return if product.blank?

    if quantity > product.quantity
      errors.add(:quantity, "exceeds available stock")
    end
  end
end
