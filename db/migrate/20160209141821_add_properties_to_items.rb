class AddPropertiesToItems < ActiveRecord::Migration
  def change
    add_column :items, :properties, :json
  end
end
