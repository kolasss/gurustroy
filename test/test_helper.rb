require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "vendor"
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'

require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # authenticate user
  def login_user user
    auth = user.authentications.first
    header_text = "Bearer #{auth_token auth}"
    @request.headers["Authorization"] = header_text
  end

  def auth_token auth
    AuthToken.encode({ auth_id: auth.id })
  end

  # for carrierwave file uploads in tests
  CarrierWave.root = Rails.root.join('test/fixtures/files')

  def after_teardown
    super
    CarrierWave.clean_cached_files!(0)
  end

  private

    def stub_smsc_request
      WebMock.stub_request(:get, /smsc.ru\/sys\/send.php/).
        to_return(:status => 200,
          :body => '1,1',
          :headers => {
            'Content-Type' => 'application/json'
          })
    end

    def require_login(&block)
      yield
      assert_response 401
    end
end

class CarrierWave::Mount::Mounter
  def store!
    # Not storing uploads in the tests
  end
end
