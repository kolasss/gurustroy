class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone, :null => false
      t.string :name
      t.string :company
      t.string :type

      t.string :crypted_password
      t.string :salt

      # remember me
      t.string   :remember_me_token,            :default => nil
      t.datetime :remember_me_token_expires_at, :default => nil

      # reset password
      t.string   :reset_password_token, :default => nil
      t.datetime :reset_password_token_expires_at, :default => nil
      t.datetime :reset_password_email_sent_at, :default => nil

      t.timestamps null: false
    end
    add_index :users, :phone, unique: true
    add_index :users, :remember_me_token
    add_index :users, :reset_password_token
  end
end
