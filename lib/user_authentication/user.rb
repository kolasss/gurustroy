require 'smsc_api'

module UserAuthentication
  module User
    extend ActiveSupport::Concern

    included do
      has_many :authentications, :dependent => :destroy
    end

    def generate_sms_code
      self.sms_code = rand(0000..9999).to_s.rjust(4, "0")
      self.sms_code_expires_at = Time.current + Rails.configuration.sms_code_expires_in_minutes.minutes
      save
    end

    def send_sms_code
      message = "Gurustroy.ru code: #{self.sms_code}"
      if Rails.env.production?
        # TODO сделать отправку смс отложенной
        sms = ::SMSC.new
        sms_response = sms.send_sms self.phone, message
        return sms_response[1] > "0"
      else
        logger.info message
        return true
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

      def sms_code_not_expired
        sms_code_expires_at.present? && sms_code_expires_at > Time.current
      end
  end
end
