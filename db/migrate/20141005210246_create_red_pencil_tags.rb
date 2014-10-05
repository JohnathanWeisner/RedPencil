class CreateRedPencilTags < ActiveRecord::Migration
  def change
    create_table :red_pencil_tags do |t|
      t.references :product, index: true
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :starting_price

      t.timestamps
    end
  end
end
