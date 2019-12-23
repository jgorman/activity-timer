require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'ownership' do
    u1 = users(:user1)
    c1 = clients(:one)
    c2 = clients(:two)

    p1 = Project.new(user: u1, client: c1, name: 'p1')
    assert p1.save, 'Correct ownership'

    p1 = Project.new(user: u1, client: c1, name: 'p1')
    assert_not p1.save, 'Duplicate name'

    p12 = Project.new(user: u1, client: c2, name: 'p12')
    assert_not p12.save, 'Wrong client user'
  end

  test 'no_project' do
    u1 = users(:user1)
    no_project = Project.no_project(u1)
    assert_equal u1, no_project.user, 'No project user'
    assert_equal '', no_project.name, 'No project no name'
    no_client = Client.no_client(u1)
    assert_equal no_client, no_project.client, 'No project no client'
  end
end
