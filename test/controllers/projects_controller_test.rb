require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:u1)
    @c1 = clients(:c1)
    @c2 = clients(:c2)
    @p1 = projects(:p1)
    @p2 = projects(:p2)
  end

  test 'index' do
    get projects_path
    assert_response :success
  end

  test 'show my projects' do
    get project_path(@p1)
    assert_response :success

    get project_path(@p2)
    assert_redirected_to error_path
  end

  test 'create projects under my clients' do
    get new_client_project_path(@c1)
    assert_response :success

    get new_client_project_path(@c2)
    assert_redirected_to error_path
  end
end
