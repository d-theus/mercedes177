class CreateCatGroups < ActiveRecord::Migration
  def change
    create_table :cat_groups do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
