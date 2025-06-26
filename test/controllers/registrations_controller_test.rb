require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include EncryptionHelper
  test "can access registration path" do
    get new_registration_path

    assert_response :success
  end

  test "directs when logged in" do
    user = users(:owner)
    sign_in(user)

    get new_registration_path

    assert_redirected_to dashboard_path
  end

  test "handles invalid tokens" do
    get new_registration_path(token: "somebadtoken")

    assert_response :success
    assert_dom "div", "Invalid token."
    assert_dom "#user_token[value=somebadtoken]", 0
  end

  test "handles valid tokens" do
    token = user_token("pizza@example.com", Time.zone.now + 15.minutes, "email_confirm")
    get new_registration_path(token:)

    assert_response :success
    assert_dom "#user_token[value='#{token}']"
    assert_dom "#user_email_address[value='pizza@example.com']"
  end

  test "creates users" do
    post registration_path, params: { user: { email_address: "taco@example.com", password: "abc123", password_confirmation: "abc123" } }

    assert_redirected_to dashboard_path
    assert ::User.find_by(email_address: "taco@example.com")
  end

  test "does not create users if password doesn't match" do
    post registration_path, params: { user: { email_address: "taco@example.com", password: "abc123", password_confirmation: "123abc" } }

    assert_response :success
    assert_not ::User.find_by(email_address: "taco@example.com")
  end
end
