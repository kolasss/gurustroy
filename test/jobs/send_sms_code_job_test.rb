require 'test_helper'

class SendSmsCodeJobTest < ActiveJob::TestCase

  test 'send sms job is working' do
    stub_smsc_request
    user = users(:customer)
    assert SendSmsCodeJob.perform_now user.phone, user.sms_code
  end

  test 'sens sms job scheduling' do
    user = users(:supplier)
    assert_enqueued_with(job: SendSmsCodeJob) do
      user.request_sms_code
    end
  end
end
