class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone, :null => false
      t.string :name
      t.string :company
      t.string :type

      t.string   :sms_code, :default => nil
      t.datetime :sms_code_expires_at, :default => nil

      t.timestamps null: false
    end
    add_index :users, :phone, unique: true
    add_index :users, :sms_code
  end
end
