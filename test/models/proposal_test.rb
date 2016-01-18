# == Schema Information
#
# Table name: proposals
#
#  id          :integer          not null, primary key
#  order_id    :integer
#  description :text
#  price       :integer
#  status      :integer          default(0), not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_proposals_on_order_id  (order_id)
#  index_proposals_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_0224a90884  (user_id => users.id)
#  fk_rails_315d700991  (order_id => orders.id)
#

require 'test_helper'

class ProposalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
