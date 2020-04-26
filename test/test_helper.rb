# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # All fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # @request is only valid after a request: get/put/post etc.
  def request_user
    return unless @request
    return unless env = @request.env
    return unless warden = env["warden"]
    warden.user
  end

  def session_user_id
    return unless session
    return unless key = session["warden.user.user.key"]
    return unless key0 = key[0]
    key0[0]
  end
end
