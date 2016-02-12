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

class UserAuthTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      phone: '79234567890',
      name: 'Проверка пользователя',
      company: 'ООО Компания'
    )
  end

  test "should have authentications" do
    user = users(:customer)
    auth = authentications(:customer_auth)
    assert user.authentications.include? auth
  end

  test "associated authentications should be destroyed" do
    @user.save
    @user.authentications.create(
      info: {user_agent: 'Test'},
    )
    assert_difference 'Authentication.count', -1 do
      @user.destroy
    end
  end

  test "method generate_sms_code" do
    @user.save
    @user.generate_sms_code
    sms_code = @user.sms_code
    sms_code_expires_at = @user.sms_code_expires_at
    @user.generate_sms_code
    assert_not_equal sms_code, @user.sms_code
    assert_not_equal sms_code_expires_at, @user.sms_code_expires_at
  end

  test "method send_sms_code" do
    stub_smsc_request
    user = users(:customer)
    assert user.send_sms_code
  end

  test "method verify_sms_code should verify sms code" do
    user = users(:customer)
    assert user.verify_sms_code user.sms_code
  end

  test "method verify_sms_code should return false if wrong sms code" do
    user = users(:customer)
    assert_not user.verify_sms_code 0000
  end

  test "method verify_sms_code should return false if sms code expired" do
    user = users(:customer)
    user.sms_code_expires_at = Time.current - 1.minute
    user.save
    assert_not user.verify_sms_code user.sms_code
  end

  test "method verify_sms_code should not verify sms code two times" do
    user = users(:customer)
    sms_code = user.sms_code
    assert user.verify_sms_code sms_code
    assert_not user.verify_sms_code sms_code
  end

  test "class method find_by_auth_id should return correct user" do
    user = users(:customer)
    auth = authentications(:customer_auth)
    found_user = User.find_by_auth_id auth.id
    assert_equal user, found_user
  end
end
