# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  file       :string
#  post_id    :integer
#  post_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_photos_on_post_type_and_post_id  (post_type,post_id)
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # assert File.exists?(@order.photo.file.path)

  # assert_difference 'Photo.count', -1 do
  # @order.update(
  #   photo_attributes: {
  #     id: @order.photo.id,
  #     _destroy: true
  #   }
  # )
  # # assert !File.exists?(order.photo.file.path)
  # assert_not @order.reload.photo.present?
end
