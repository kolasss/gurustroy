# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def setup
    @category = Category.new(
      name: 'Проверка категории'
    )
  end

  test "should be valid" do
    assert @category.valid?
  end

  test "name should be present" do
    @category.name = nil
    assert_not @category.valid?
  end

  test "name should be uniq" do
    @category.name = categories(:instrumenti).name
    assert_not @category.valid?
  end

  test "should have orders" do
    category = categories(:instrumenti)
    order = orders(:order_one)
    assert category.orders.include? order
  end

  test "should not allow destroy with exist order" do
    @category.save
    order = orders(:order_one)
    order.category = @category
    order.save
    assert_not @category.destroy
  end

  test "should have tags" do
    category = categories(:instrumenti)
    tag = tags(:molotok)
    assert category.tags.include? tag
  end

  test "associated tags should be destroyed" do
    @category.save
    @category.tags.create(name: 'Проверочный таг')
    assert_difference 'Tag.count', -1 do
      @category.destroy
    end
  end

  test "method find_by_tag_name should return list with right category" do
    category = categories(:instrumenti)
    category_not = categories(:kirpichi)
    tag = tags(:molotok)
    categories = Category.find_by_tag_name(tag.name)
    assert categories.include? category
    assert_not categories.include? category_not
  end

  test "method version" do
    version = Category.version
    last_update_version = Category.maximum(:updated_at).to_i
    assert_equal version, last_update_version
  end
end
