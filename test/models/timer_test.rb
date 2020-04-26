# frozen_string_literal: true

require "test_helper"

class TimerTest < ActiveSupport::TestCase
  test "ownership" do
    u1 = users(:u1)
    p1 = projects(:p1)
    p2 = projects(:p2)

    t1 = Timer.new(user: u1, project: p1, start: Time.now, name: "name")
    assert t1.save, "Correct ownership"

    # Only one timer per user.
    t2 = Timer.new(user: u1, project: p1, start: Time.now, name: "name")
    assert_raises { t2.save }
    assert t1.destroy

    t3 = Timer.new(user: u1, project: p2, start: Time.now, name: "name")
    assert_not t3.save, "Wrong project user"
  end
end
