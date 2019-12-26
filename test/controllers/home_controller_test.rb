require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_path
    assert_response :success
  end

  test 'error page' do
    get error_path
    assert_response :success
  end
end
