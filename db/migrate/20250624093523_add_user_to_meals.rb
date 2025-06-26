class AddUserToMeals < ActiveRecord::Migration[8.0]
  def change
    add_reference :meals, :user, null: false, foreign_key: true
  end
end
