class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :serial,
    :price, :count, :notice,
    :category_id, :created_at, :updated_at,
    :body, :properties, :category
end
