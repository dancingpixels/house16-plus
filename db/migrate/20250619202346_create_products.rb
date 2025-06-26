class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, null: false, precision: 8, scale: 2
      t.integer :quantity, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
