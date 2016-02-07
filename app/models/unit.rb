# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Unit < ActiveRecord::Base
  has_many :orders, :dependent => :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
