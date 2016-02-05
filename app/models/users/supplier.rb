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

class Supplier < User
  has_many :proposals, :dependent => :restrict_with_error, foreign_key: "user_id"
  has_many :orders, through: :proposals

  private

    def after_type_change
      proposals.live.each(&:deleted!)
    end
end
