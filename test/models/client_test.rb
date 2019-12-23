require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test 'no_client' do
    u1 = users(:user1)
    no_client = Client.no_client(u1)
    assert_equal u1, no_client.user, 'Correct user'
    assert_equal '', no_client.name, 'No client no name'

    c3 = Client.new(user: u1)
    assert_not c3.save, 'Duplicate name'
  end
end
