class RenameOrdersShippingInfo < ActiveRecord::Migration
  def change
    rename_column :orders, :shipping_info, :notice
  end
end
