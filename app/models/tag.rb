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
  include PgSearch

  belongs_to :category

  before_save :format_name

  validates :name, :presence => true
  validates :category, :presence => true

  pg_search_scope :search_by_name,
    :against => :name,
    :using => {
      :tsearch => {:prefix => true}
    }

  private

    def format_name
      self.name = self.name.mb_chars.downcase.to_s
    end
end
