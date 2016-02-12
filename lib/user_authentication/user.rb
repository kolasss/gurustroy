require 'smsc_api'

module UserAuthentication
  module User
    extend ActiveSupport::Concern

    included do
      has_many :authentications, :dependent => :destroy
    end

    def request_sms_code
      if sms_code_not_expired
        errors.add :sms_code, 'not expired'
        return false
      else
        generate_sms_code
        send_sms_code
      end
    end

    def verify_sms_code code
      valid = self.sms_code.present? && self.sms_code == code && sms_code_not_expired
      update_attributes(sms_code: nil, sms_code_expires_at:nil) if valid
      return valid
    end

    module ClassMethods
      def find_by_auth_id auth_id
        joins(:authentications).merge(Authentication.where id: auth_id).first
      end
    end

    private

      def generate_sms_code
        self.sms_code = rand(0000..9999).to_s.rjust(4, "0")
        self.sms_code_expires_at = Time.current + Rails.configuration.sms_code_expires_in_minutes.minutes
        save
      end

      def send_sms_code
        SendSmsCodeJob.perform_later self.phone, self.sms_code
      end

      def sms_code_not_expired
        sms_code_expires_at.present? && sms_code_expires_at > Time.current
      end
  end
end
