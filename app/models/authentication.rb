# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  info       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authentications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_08833fecbe  (user_id => users.id)
#

class Authentication < ActiveRecord::Base
  belongs_to :user
end
