ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    SIGNED_COOKIE_SALT = "signed cookie"

    def sign_in(user)
      cookies[:session_id] = Rails.application.message_verifier(SIGNED_COOKIE_SALT).generate(user.sessions.create.id)
    end

    def basic_status_content
      [
        { name: "Yesterday", content: [ "i", "love", "tacos", "yesterday" ] },
        { name: "Today", content: [ "i", "love", "tacos", "today" ] },
        { name: "Links", content: [ "i", "love", "tacos", "all the time" ] }
      ]
    end
  end
end
