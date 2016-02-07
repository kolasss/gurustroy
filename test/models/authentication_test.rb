# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  info       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authentications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_08833fecbe  (user_id => users.id)
#

require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase

  def setup
    @auth = Authentication.new(
      info: {user_agent: 'Test'},
      user: User.first
    )
  end

  test "should be valid" do
    assert @auth.valid?
  end

  test "user should be present" do
    @auth.user = nil
    assert_not @auth.valid?
  end
end
