# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "welcome page" do
    get root_path
    assert_response :success
    assert_select "span", "Welcome to Activity Timer"
  end

  test "alert page" do
    get alert_path
    assert_response :success
    assert_select "span", "Alert"
  end

  test "login as guest user" do
    post guest_home_index_path
    assert_redirected_to timer_path
    assert_not flash[:notice]
    assert_equal "guest", request_user.role_s, "Uninvited."
  end

  test "become guest user" do
    u1 = users(:u1)
    sign_in u1
    get root_path
    assert_response :success
    assert_equal u1.id, session_user_id

    post guest_home_index_path
    assert_redirected_to timer_path
    assert_not flash[:notice]
    assert_equal "guest", request_user.role_s, "Uninvited."
  end

  test "missing guest user" do
    guest = users(:guest)
    guest.destroy!
    post guest_home_index_path
    assert_redirected_to alert_path
    assert_equal "No guest user available now. Sorry.", flash[:notice]
  end
end
