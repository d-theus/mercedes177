class ChangeOrdersStatus < ActiveRecord::Migration
  def change
    change_column :orders, :status, :string, default: 'Новый', null: false
  end
end
