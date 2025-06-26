class Meal < ApplicationRecord
  belongs_to :user
  validates  :description, presence: true
  validates  :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
