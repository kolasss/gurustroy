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

  validates :phone, :presence => true

  # STI models list
  USER_TYPES = [
    'Customer',
    'Supplier',
    'Admin'
  ]

  USER_TYPES.each do |method|
    # определяем методы типа customer?, supplier?
    define_method "#{method.downcase}?" do
      type == method
    end

    # определяем методы типа customer!, supplier!
    define_method "#{method.downcase}!" do
      new_inst = becomes! method.constantize
      new_inst.save
      return new_inst
    end
  end

end
