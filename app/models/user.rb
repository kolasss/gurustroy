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
  before_validation :format_phone

  validates :phone,
      presence: true,
      uniqueness: true,
      phony_plausible: true # validate format
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
      # пересоздаем себя для обработки ошибок
      new_inst = becomes! method.constantize
      new_inst.save
      return new_inst
    end
  end

  def change_type new_type
    if USER_TYPES.include? new_type
      return self.send("#{new_type.downcase}!")
    else
      errors.add :type
      return self
    end
  end

  def self.policy_class
    UserPolicy
  end

  private

    def set_defaults
      self.type ||= 'Customer'
    end

    def format_phone
      self.phone.gsub!(/[^0-9]/i, '') if self.phone.present?
    end
end
