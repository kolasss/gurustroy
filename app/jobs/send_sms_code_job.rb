class SendSmsCodeJob < ActiveJob::Base
  queue_as :default

  def perform(phone, sms_code)
    # TODO сделать обработку задач через ассинхронный бэкенд, например Sidekiq
    message = "Gurustroy.ru code: #{sms_code}"
    if Rails.env.production? || Rails.env.test?
      sms = ::SMSC.new
      sms_response = sms.send_sms phone, message
      # return sms_response[1] > "0" # проверка ответа от smsc.ru на код ошибки
    else
      logger.info message
      return true
    end
  end
end
