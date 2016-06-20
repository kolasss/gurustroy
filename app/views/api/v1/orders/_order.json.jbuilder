json.merge! order.as_json
json.partial! 'api/v1/photos/photo', photo: order.photo if order.photo.present?
json.user do
  json.partial! 'api/v1/users/user', user: order.user
end
