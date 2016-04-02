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

  # STI models list
  USER_TYPES = [
    'Customer',
    'Supplier',
    'Admin'
  ]

  # user types for signup users
  PUBLIC_USER_TYPES = USER_TYPES - ['Admin']

  validates :phone,
      presence: true,
      uniqueness: true,
      phony_plausible: true # validate format
  validates :type, inclusion: { in: USER_TYPES }

  scope :by_created, -> { order(created_at: :desc) }

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
      transaction do
        new_inst = self.send("#{new_type.downcase}!")
        # обработа заказов и предложений после смены типа
        after_type_change if new_inst.errors.empty?
        return new_inst
      end
    else
      errors.add :type
      return self
    end
  end

  def User.policy_class
    UserPolicy
  end

  private

    def set_defaults
      self.type ||= 'Customer'
    end

    def format_phone
      self.phone = PhoneUtil.format(self.phone) if self.phone.present?
    end

    def after_type_change
      raise NotImplementedError
    end
end
