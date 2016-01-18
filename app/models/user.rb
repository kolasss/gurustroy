# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  phone               :string           not null
#  name                :string
#  company             :string
#  type                :string
#  sms_code            :string
#  sms_code_expires_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_phone     (phone) UNIQUE
#  index_users_on_sms_code  (sms_code)
#

class User < ActiveRecord::Base
  include UserAuthentication::User

  before_validation :set_defaults

  validates :phone, presence: true, uniqueness: true
  validates :type, presence: true

  # STI models list
  USER_TYPES = [
    'Customer',
    'Supplier',
    'Admin'
  ]

  # user types for signup users
  PUBLIC_USER_TYPES = USER_TYPES - ['Admin']

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

  def self.policy_class
    UserPolicy
  end

  private

    def set_defaults
      self.type ||= 'Customer'
    end
end
