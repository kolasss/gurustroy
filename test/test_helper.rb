require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

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
end

class CarrierWave::Mount::Mounter
  def store!
    # Not storing uploads in the tests
  end
end
