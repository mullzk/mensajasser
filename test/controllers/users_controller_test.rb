require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:user)
    @admin.username = "admin"
    @admin.password = "password"
    @admin.save
    @empty_round_necessary_for_building_layout = FactoryBot.create(:round)
    @empty_round_necessary_for_building_layout.day = Date.today
    @empty_round_necessary_for_building_layout.save
    
    
  end

  test "should get index" do
    get users_url
    assert_response :redirect
    post "/login", params: {name: @admin.username, password: @admin.password }
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :redirect
    post "/login", params: {name: @admin.username, password: @admin.password }
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    post "/login", params: {name: @admin.username, password: @admin.password }
    assert_difference('User.count') do
      post users_url, params: { user: {  } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :redirect
    post "/login", params: {name: @admin.username, password: @admin.password }
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :redirect
    post "/login", params: {name: @admin.username, password: @admin.password }
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: {  } }
    assert_response :redirect
    post "/login", params: {name: @admin.username, password: @admin.password }
    patch user_url(@user), params: { user: {  } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    post "/login", params: {name: @admin.username, password: @admin.password }
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

end
