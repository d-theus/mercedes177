class AddBodyToItems < ActiveRecord::Migration
  def change
    add_column :items, :body, :string
  end
end
