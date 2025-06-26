class Product < ApplicationRecord
  belongs_to :category
  has_many :line_items

  # Only products with stock > 0
  scope :available, -> { where("quantity > 0") }

  validates :name, presence: true
  validates :category, presence: true
  validates :price, presence: true,
             numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true,
             numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def in_stock?
    quantity > 0
  end
end
