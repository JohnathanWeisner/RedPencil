class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.datetime :red_pencil_tag_started_at

      t.timestamps
    end
  end
end
