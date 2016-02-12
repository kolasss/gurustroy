require 'test_helper'

class SendSmsCodeJobTest < ActiveJob::TestCase

  test 'send sms job is working' do
    stub_smsc_request
    user = users(:customer)
    assert SendSmsCodeJob.perform_now user.phone, user.sms_code
  end

  test 'sens sms job scheduling' do
    user = users(:customer)
    assert_enqueued_with(job: SendSmsCodeJob, args: [user.phone, user.sms_code]) do
      user.send_sms_code
    end
  end
end
