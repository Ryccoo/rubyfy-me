require 'test_helper'

class CustomControllerTest < ActionController::TestCase
  test "should get paralellism" do
    get :paralellism
    assert_response :success
  end

end
