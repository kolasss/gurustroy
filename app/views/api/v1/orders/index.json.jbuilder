# json.array! @orders do |order|
#   json.merge! order.attributes
#   json.photo order.photo, :id, :file if order.photo.present?
# end
json.array! @orders, partial: 'order', as: :order
