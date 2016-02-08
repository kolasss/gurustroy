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

class SupplierTest < ActiveSupport::TestCase

  test "should have proposals" do
    user = users(:supplier)
    proposal = proposals(:proposal_one)
    assert user.proposals.include? proposal
  end

  test "should not allow destroy with exist proposal" do
    user = Supplier.create(phone: '81232567890')
    proposal = proposals(:proposal_one)
    proposal.user = user
    proposal.save
    assert_not user.destroy
  end

  test "should have orders through proposals" do
    user = users(:supplier)
    proposal = user.proposals.first
    assert user.orders.include? proposal.order
    another_order = orders(:without_proposals)
    assert_not user.orders.include? another_order
  end

  test "method change_type should correctly handle proposals after type change" do
    user = users(:supplier)
    live_proposal = proposals(:proposal_one)
    rejected_proposal = proposals(:rejected)
    user = user.change_type 'Customer'
    assert live_proposal.reload.deleted?
    assert_not rejected_proposal.reload.deleted?
  end
end
