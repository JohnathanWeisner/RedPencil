class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.datetime :price_updated_at, default: DateTime.now

      t.timestamps
    end
  end
end
