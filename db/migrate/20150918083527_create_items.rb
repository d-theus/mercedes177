class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :serial
      t.float :price
      t.integer :count, default: 0, null: false
      t.text :description
      t.text :notice
      t.references :category, index: true

      t.timestamps
    end
  end
end
