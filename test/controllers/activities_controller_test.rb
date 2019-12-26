require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:u1)
    @p1 = projects(:p1)
    @p2 = projects(:p2)
    @a1 = activities(:a1)
    @a2 = activities(:a2)
  end

  test 'index' do
    get projects_path
    assert_response :success
  end

  test 'only my activities' do
    get edit_activity_path(@a1)
    assert_response :success

    get edit_activity_path(@a2)
    assert_redirected_to error_path
  end

  test 'create activities under my projects' do
    get new_project_activity_path(@p1)
    assert_response :success

    get new_project_activity_path(@p2)
    assert_redirected_to error_path
  end
end
