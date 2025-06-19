class CreateMeals < ActiveRecord::Migration[8.0]
 def change
    create_table :meals do |t|
      t.string :description, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0.00, null: false

      t.timestamps
    end
  end
end
