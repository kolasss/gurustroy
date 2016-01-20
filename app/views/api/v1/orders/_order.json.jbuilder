json.merge! order.attributes
json.photo order.photo, :id, :file if order.photo.present?
