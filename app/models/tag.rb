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

class Tag < ActiveRecord::Base
  belongs_to :category

  validates :name, :presence => true
  validates :category, :presence => true
end
