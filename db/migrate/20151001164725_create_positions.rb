class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :item_id
      t.integer :order_id
      t.integer :count, null: false, default: 1

      t.timestamps
    end

    add_index :positions, :item_id
    add_index :positions, :order_id
  end
end
