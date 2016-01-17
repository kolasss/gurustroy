class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true, foreign_key: true
      t.json :info

      t.timestamps null: false
    end
  end
end
