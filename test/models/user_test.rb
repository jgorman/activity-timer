require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'default role is user' do
    no_role_user =
      User.new(
        email: 'user@user.com',
        first_name: 'Human',
        last_name: 'Being',
        password: 'beingness'
      )
    assert no_role_user.save!
    assert no_role_user.role_s == 'user'

    # Catch missing role.
    no_role_user.role_s = ''
    assert_not no_role_user.save
  end

  test 'use provided role' do
    admin_user =
      User.new(
        email: 'admin@user.com',
        first_name: 'Admin',
        last_name: 'Dude',
        password: 'knowingness',
        role_s: 'admin'
      )
    assert admin_user.save!
    assert admin_user.role_s == 'admin'
  end
end
