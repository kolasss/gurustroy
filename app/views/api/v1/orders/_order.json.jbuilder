json.merge! order.attributes
json.partial! 'api/v1/photos/photo', photo: order.photo if order.photo.present?
