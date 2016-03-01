class ItemCardSerializer < ActiveModel::Serializer
  attributes :id, :name, :serial, :thumb, :price, :count, :body

  def thumb
    object.featured_or_first_photo
    .try(:image)
    .try(:thumb)
    .try(:url)
  end
end
