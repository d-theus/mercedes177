class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :first_name, null: false
      t.string :middle_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :status, null: false, default: 'new'
      t.text :address, null: false
      t.text :shipping_info

      t.timestamps
    end
  end
end
