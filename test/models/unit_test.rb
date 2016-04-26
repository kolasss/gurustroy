# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UnitTest < ActiveSupport::TestCase

  def setup
    @unit = Unit.new(
      name: 'Проверка тага'
    )
  end

  test "should be valid" do
    assert @unit.valid?
  end

  test "name should be present" do
    @unit.name = nil
    assert_not @unit.valid?
  end

  test "name should be uniq" do
    @unit.name = units(:kg).name
    assert_not @unit.valid?
  end

  test "should have orders" do
    unit = units(:kg)
    order = orders(:order_two)
    assert unit.orders.include? order
  end

  test "should not allow destroy with exist order" do
    @unit.save
    order = orders(:order_one)
    order.unit = @unit
    order.save
    assert_not @unit.destroy
  end

  test "method version" do
    version = Unit.version
    last_update_version = Unit.maximum(:updated_at).to_i
    assert_equal version, last_update_version
  end
end
