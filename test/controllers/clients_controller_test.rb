require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:u1)
    @c1 = clients(:c1)
    @c2 = clients(:c2)
  end

  test 'index' do
    get clients_path
    assert_response :success
  end

  test 'show my clients' do
    get client_path(@c1)
    assert_response :success

    get client_path(@c2)
    assert_redirected_to error_path
  end
end
