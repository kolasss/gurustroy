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

class CustomerTest < ActiveSupport::TestCase

  test "should have orders" do
    user = users(:customer)
    order = orders(:order_one)
    assert user.orders.include? order
  end

  test "should not allow destroy with exist order" do
    user = Customer.create(phone: '81232567890')
    order = orders(:order_one)
    order.user = user
    order.save
    assert_not user.destroy
  end

  test "method change_type should correctly handle orders after type change" do
    user = users(:customer)
    live_order = orders(:order_one)
    finished_order = orders(:order_two)
    user = user.change_type 'Supplier'
    assert live_order.reload.canceled?
    assert_not finished_order.reload.canceled?
  end
end
