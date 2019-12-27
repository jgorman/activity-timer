require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  Password = 'guest123'

  test 'update user' do
    u1 = users(:u1)
    sign_in u1

    put user_registration_path,
        params: { user: { last_name: 'Bond2', current_password: Password } }

    assert_redirected_to root_path
    assert_equal 'Your account has been updated successfully.', flash[:notice]
    updated = User.find(u1.id)
    assert_equal 'Bond2', updated.last_name
  end

  test 'delete user' do
    u1 = users(:u1)
    sign_in u1

    delete user_registration_path

    assert_redirected_to root_path
    assert_equal 'Bye! Your account has been successfully cancelled. We hope to see you again soon.', flash[:notice]
    assert_not User.find_by_id(u1.id), "User not deleted."
  end

  test 'guest not self update' do
    guest = users(:guest)
    sign_in guest

    put user_registration_path,
        params: { user: { last_name: 'Bond2', current_password: Password } }

    assert_redirected_to alert_path
    assert_equal 'Guest users cannot update themselves.', flash[:notice]
    updated = User.find(guest.id)
    assert_not_equal 'Bond2', updated.last_name
  end

  test 'guest not self delete' do
    guest = users(:guest)
    sign_in guest

    delete user_registration_path

    assert_redirected_to alert_path
    assert_equal 'Guest users cannot delete themselves.', flash[:notice]
    assert User.find_by_id(guest.id), "Guest self deleted."
  end

end
