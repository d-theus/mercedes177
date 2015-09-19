class ChangeItemsCountDefault < ActiveRecord::Migration
  def change
    change_column :items, :count, :integer, default: 0, null: false
  end
end
