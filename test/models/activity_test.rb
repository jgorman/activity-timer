require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test 'ownership' do
    u1 = users(:user1)
    c1 = clients(:one)
    p1 = projects(:one)
    np1 = Project.no_project(u1)

    c2 = clients(:two)
    p2 = projects(:two)

    a1 =
      Activity.new(
        user: u1,
        client: c1,
        project: p1,
        start: Time.now,
        length: 600,
        name: 'name'
      )
    assert a1.save, 'Correct ownership'

    a2 =
      Activity.new(
        user: u1,
        client: c2,
        project: p2,
        start: Time.now,
        length: 600,
        name: 'name'
      )
    assert_not a2.save, 'Wrong client user'

    a3 =
      Activity.new(
        user: u1,
        client: c1,
        project: np1,
        start: Time.now,
        length: 600,
        name: 'name'
      )
    assert_not a3.save, 'Wrong project client'
  end
end
