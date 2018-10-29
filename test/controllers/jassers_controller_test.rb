require 'test_helper'

class JassersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jasser = FactoryBot.create(:jasser)
    @latest_round = FactoryBot.create(:round_with_date) # Default Layout needs a dated round for @last_entered_round.day
  end

  test "should get index" do
    get jassers_url
    assert_response :success
  end

  test "should get new" do
    get new_jasser_url
    assert_response :success
  end

  test "should create jasser" do
    assert_difference('Jasser.count') do
      post jassers_url, params: { jasser: {  } }
    end

    assert_redirected_to jasser_url(Jasser.last)
  end

  test "should show jasser" do
    get jasser_url(@jasser)
    assert_response :success
  end

  test "should get edit" do
    get edit_jasser_url(@jasser)
    assert_response :success
  end

  test "should update jasser" do
    patch jasser_url(@jasser), params: { jasser: {  } }
    assert_redirected_to jasser_url(@jasser)
  end

  test "should destroy jasser" do
    assert_difference('Jasser.count', -1) do
      delete jasser_url(@jasser)
    end

    assert_redirected_to jassers_url
  end
end
