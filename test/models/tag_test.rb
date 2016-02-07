# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tags_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_96a8141007  (category_id => categories.id)
#

require 'test_helper'

class TagTest < ActiveSupport::TestCase

  def setup
    @tag = Tag.new(
      name: 'Проверка тага',
      category: categories(:kirpichi)
    )
  end

  test "should be valid" do
    assert @tag.valid?
  end

  test "name should be present" do
    @tag.name = nil
    assert_not @tag.valid?
  end

  test "category should be present" do
    @tag.category = nil
    assert_not @tag.valid?
  end

  test "method search_by_name should return correct tags" do
    tag = tags(:molotok)
    tag_not = tags(:otvertka)
    tags = Tag.search_by_name tag.name
    assert tags.include? tag
    assert_not tags.include? tag_not
  end

  test "should downcase name before save" do
    downcased_name = @tag.name.mb_chars.downcase.to_s
    @tag.save
    assert_equal downcased_name, @tag.name
  end
end
