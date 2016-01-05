# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  phone      :string
#  name       :string
#  company    :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
end
