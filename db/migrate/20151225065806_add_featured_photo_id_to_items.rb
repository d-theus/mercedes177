class AddFeaturedPhotoIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :featured_photo_id, :integer, null: true
  end
end
