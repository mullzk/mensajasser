require 'test_helper'

class JassersControllerTest < ActionDispatch::IntegrationTest
  test "Test Resourceful Routing of Jassers" do 
    assert_routing({ path: 'jassers', method: :get }, { controller: 'jassers', action: 'index' })
    assert_routing({ path: 'jassers/2', method: :get }, { controller: 'jassers', action: 'show', id: "2" })
    assert_routing({ path: 'jassers/2/edit', method: :get }, { controller: 'jassers', action: 'edit', id: "2" })
  end

  test "Test Resourceful Routing of Rounds" do 
    assert_routing({ path: 'rounds', method: :get }, { controller: 'rounds', action: 'index' })
    assert_routing({ path: 'rounds/2', method: :get }, { controller: 'rounds', action: 'show', id: "2" })
    assert_routing({ path: 'rounds/2/edit', method: :get }, { controller: 'rounds', action: 'edit', id: "2" })
  end

  test "Test Resourceful Routing of Users" do 
    assert_routing({ path: 'users', method: :get }, { controller: 'users', action: 'index' })
    assert_routing({ path: 'users/2', method: :get }, { controller: 'users', action: 'show', id: "2" })
    assert_routing({ path: 'users/2/edit', method: :get }, { controller: 'users', action: 'edit', id: "2" })
  end
  
  
  test "Routing of Ranking-Controller" do 
    assert_routing({ path: 'ranking/month/2018-09-28', method: :get }, { controller: 'ranking', action: 'month' , date: '2018-09-28'})    
  end
end