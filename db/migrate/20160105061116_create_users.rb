class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone
      t.string :name
      t.string :company
      t.string :type

      t.timestamps null: false
    end
  end
end
