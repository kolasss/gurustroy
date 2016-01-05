class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :description
      t.float :quantity
      t.references :unit, index: true, foreign_key: true
      t.integer :price
      t.integer :status, null: false, default: 0
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
