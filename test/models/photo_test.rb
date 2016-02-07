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

  def setup
    @photo = Photo.new(
      file: Rack::Test::UploadedFile.new(
        File.join(ActionController::TestCase.fixture_path, '/files/mister.jpg'),
        'image/jpg'
      ),
      post: orders(:order_two)
    )
  end

  test "should be valid" do
    assert @photo.valid?
    assert File.exists?(@photo.file.path)
  end

  test "file should be present" do
    photo = Photo.new(
      post: orders(:order_two)
    )
    assert_not photo.valid?
  end
end
