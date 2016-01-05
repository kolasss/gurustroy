class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.references :order, index: true, foreign_key: true
      t.text :description
      t.integer :price
      t.integer :status, null: false, default: 0
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
