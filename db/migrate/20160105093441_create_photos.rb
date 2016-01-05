class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :file
      t.references :post, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
