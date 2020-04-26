# frozen_string_literal: true

require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "ownership" do
    u1 = users(:u1)
    c1 = clients(:c1)
    p1 = projects(:p1)
    np1 = Project.no_project(u1)

    c2 = clients(:c2)
    p2 = projects(:p2)

    a111 =
      Activity.new(
        user: u1,
        client: c1,
        project: p1,
        start: Time.now,
        length: 600,
        name: "name"
      )
    assert a111.save, "Correct ownership"

    a122 =
      Activity.new(
        user: u1,
        client: c2,
        project: p2,
        start: Time.now,
        length: 600,
        name: "name"
      )
    assert_not a122.save, "Wrong client user"

    a11np =
      Activity.new(
        user: u1,
        client: c1,
        project: np1,
        start: Time.now,
        length: 600,
        name: "name"
      )
    assert_not a11np.save, "No project client != client"
  end
end
