# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  phone                           :string           not null
#  name                            :string
#  company                         :string
#  type                            :string
#  crypted_password                :string
#  salt                            :string
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_phone                 (phone) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :orders, :dependent => :restrict_with_error
  has_many :proposals, :dependent => :restrict_with_error

  validates :phone, :presence => true
end
