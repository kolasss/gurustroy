# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  has_many :orders, :dependent => :restrict_with_error
  has_many :tags, :dependent => :destroy

  validates :name, :presence => true

  def Category.find_by_tag_name name
    name = name.mb_chars.downcase.to_s
    Category.joins(:tags).merge(Tag.search_by_name name)
  end
end
