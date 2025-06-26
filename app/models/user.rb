class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum   :role, { sales: 0, admin: 1 }

  has_many  :invoices, dependent: :nullify
  has_many  :products, dependent: :nullify
  has_many  :meals,    dependent: :nullify
  has_many  :meals,    dependent: :nullify

  validates :name, :role, presence: true
end
