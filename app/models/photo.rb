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

class Photo < ActiveRecord::Base
  belongs_to :post, polymorphic: true

  mount_uploader :file, PhotoUploader

  validates :file, :presence => true
  # validates :post, :presence => true
end
