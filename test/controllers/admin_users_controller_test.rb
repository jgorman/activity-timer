# frozen_string_literal: true

require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "admin only" do
    sign_in users(:u1)
    get admin_users_path
    assert_redirected_to alert_path
    assert_equal "Unauthorized access.", flash[:notice]

    sign_in users(:admin)
    get admin_users_path
    assert_response :success
  end

  test "become another user" do
    admin = users(:admin)
    sign_in admin
    get admin_users_path
    assert_response :success
    assert_equal admin.id, session_user_id

    u1 = users(:u1)
    post become_admin_user_path(u1.id)
    assert_redirected_to timer_path
    assert_equal u1.id, session_user_id, "Become failed."
  end
end
