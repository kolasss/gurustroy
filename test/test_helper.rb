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
end
