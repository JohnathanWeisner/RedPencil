class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.boolean :red_pencil_tag, :default => false

      t.timestamps
    end
  end
end
