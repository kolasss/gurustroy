# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  description :text
#  quantity    :float
#  unit_id     :integer
#  price       :integer
#  status      :integer          default(0), not null
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_category_id  (category_id)
#  index_orders_on_unit_id      (unit_id)
#  index_orders_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_3dd05aae5e  (category_id => categories.id)
#  fk_rails_b6a4a01c33  (unit_id => units.id)
#  fk_rails_f868b47f6a  (user_id => users.id)
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
