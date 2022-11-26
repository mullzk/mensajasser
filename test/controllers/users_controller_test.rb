require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:user, username: 'admin', password: 'password')
    @latest_round_necessary_for_building_layout = FactoryBot.create(:round_with_date)
  end

  test 'should get index' do
    get users_url
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    post '/login', params: { name: @admin.username, password: @admin.password }
    assert_difference('User.count') do
      post users_url, params: { user: {} }
    end

    assert_redirected_to user_url(User.last)
  end

  test 'should show user' do
    get user_url(@user)
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: { user: {} }
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    patch user_url(@user), params: { user: {} }
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    post '/login', params: { name: @admin.username, password: @admin.password }
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test 'should not get index after logout' do
    get users_url
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    get users_url
    assert_response :success
    get '/logout'
    get users_url
    assert_redirected_to :login
  end

  test 'should not get to password-change-page if not logged in' do
    get '/change_password'
    assert_redirected_to :login
    post '/login', params: { name: @admin.username, password: @admin.password }
    get '/change_password'
    assert_response :success
  end

  test 'password change should reflect in login' do
    newpass = 'newpassword'
    post '/login', params: { name: @admin.username, password: @admin.password }
    patch '/change_password',
          params: { old_password: @admin.password, "user[password]": newpass, "user[password_confirmation]": newpass }
    get '/logout'
    post '/login', params: { name: @admin.username, password: @admin.password }
    get users_url
    assert_redirected_to :login  # As we tried to login with the old password, we should get redirected to the login-page
    post '/login', params: { name: @admin.username, password: newpass }
    get users_url
    assert_response :success
  end

  test 'should not be able to change password with wrong old password' do
    newpass = 'newpassword'
    post '/login', params: { name: @admin.username, password: @admin.password }
    patch '/change_password',
          params: { old_password: 'wrong_password', "user[password]": newpass,
                    "user[password_confirmation]": newpass }
    assert_response :success # On wrong password, we stay on the change_own_password-page and therefor get a success
    patch '/change_password',
          params: { old_password: @admin.password, "user[password]": newpass,
                    "user[password_confirmation]": newpass }
    assert_redirected_to root_path # On correct password, the password gets updated and we are redirect to the Applications Root
  end
end
