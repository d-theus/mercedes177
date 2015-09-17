class CreateCatGroupCategoryAssoc < ActiveRecord::Migration
  def change
    create_table :cat_groups_categories, id: false do |t|
      t.belongs_to :cat_group, index: true
      t.belongs_to :category, index: true
    end
  end
end
