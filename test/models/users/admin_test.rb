# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  phone               :string           not null
#  name                :string
#  company             :string
#  type                :string
#  sms_code            :string
#  sms_code_expires_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_phone     (phone) UNIQUE
#  index_users_on_sms_code  (sms_code)
#

require 'test_helper'

class AdminTest < ActiveSupport::TestCase

  test "should not have orders" do
    user = users(:admin)
    assert_raise NoMethodError do
      user.orders
    end
  end
end
