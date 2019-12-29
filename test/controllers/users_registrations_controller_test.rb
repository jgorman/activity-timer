require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  Password = 'guest123'

  test 'user registration' do
    user_h = {
      email: 'somebody@gmail.com',
      password: Password,
      role_s: 'user',
      first_name: 'Some',
      last_name: 'Body'
    }

    post user_registration_path, params: { user: user_h }
    assert_redirected_to timer_path
    user = User.find(session_user_id)
    assert_equal user_h[:email], user.email
    follow_redirect!
    assert_select 'p', 'No activities.'
  end

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
    assert_match /successfully cancelled/, flash[:notice]
    assert_not User.find_by_id(u1.id), 'User not deleted.'
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
    assert User.find_by_id(guest.id), 'Guest self deleted.'
  end
end
