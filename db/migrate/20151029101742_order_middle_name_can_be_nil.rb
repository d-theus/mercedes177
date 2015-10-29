class OrderMiddleNameCanBeNil < ActiveRecord::Migration
  def change
    change_column :orders, :middle_name, :string, null: true
  end
end
