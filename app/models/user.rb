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
  has_many :authentications, :dependent => :destroy

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

  def generate_sms_code
    self.sms_code = rand(0000..9999).to_s.rjust(4, "0")
    self.sms_code_expires_at = Time.current + Rails.application.config.sms_code_expires_in_minutes.minutes
    save
  end

  def send_sms_code
    # TODO сделать отправку кода по смс
    p "sending code: #{self.sms_code}"
  end

  def verify_sms_code code
    valid = self.sms_code == code && sms_code_expires_at > Time.current
    update_attributes(sms_code: nil, sms_code_expires_at:nil) if valid
    return valid
  end

  def User.find_by_auth_id auth_id
    User.joins(:authentications).merge(Authentication.where id: auth_id).first
  end

  private

    def set_defaults
      self.type ||= 'Customer'
    end
end
