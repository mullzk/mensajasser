require 'test_helper'

class RoundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @round = FactoryBot.create(:round)
    @latest_round = FactoryBot.create(:round_with_date) # Default Layout needs a dated round for @last_entered_round.day
    
  end

  test "should get index" do
    @round.day = Date.today  # A round without a date leads to a nil-error in the view
    @round.save
    get rounds_url
    assert_response :success
  end

  test "should get new" do
    login_as_admin
    
    get new_round_url
    assert_response :success
  end

  test "should create round" do
    login_as_admin

    assert_difference('Round.count') do
      post rounds_url, params: { round: {  } }
    end

    assert_redirected_to controller:"ranking", action:"day"
  end

  test "should show round" do
    get round_url(@round)
    assert_response :success
  end

  test "should get edit" do
    login_as_admin
    get edit_round_url(@round)
    assert_response :success
  end

  test "should update round" do
    login_as_admin
    patch round_url(@round), params: { round: {  } }
    assert_redirected_to round_url(@round)
  end

  test "should destroy round" do
    login_as_admin
    assert_difference('Round.count', -1) do
      delete round_url(@round)
    end

    assert_redirected_to rounds_url
  end
  
  test "should not get to create-page if not logged in" do
   get new_round_url
   assert_redirected_to :login
   login_as_admin
   get new_round_url
   assert_response :success
  end


  test "should not be able to update anything if not logged in" do
    patch round_url(@round), params: { round: {  } }
    assert_redirected_to :login
    login_as_admin
    patch round_url(@round), params: { round: {  } }
    assert_redirected_to round_url(@round)
  end
  

  
  test "editing a round should edit the results as well" do
    login_as_admin
    round = Round.new
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.day = Date.today
    round.save
    first_result = round.results.first

    assert(first_result.differenz==200, "Differenz should be 200 as constructed")
    patch round_url(round), params: { round: { results_attributes: {"0" => {differenz:190, id:first_result.id}}}, id: round.id }
    updated_result = Result.find(first_result.id)
    assert(updated_result.differenz==190, "Differenz should be reduced to 190, but is #{round.results.first.differenz}")
  end
  
  
  
  private

  def login_as_admin
    @admin = FactoryBot.create(:user)
    @admin.username = "admin"
    @admin.password = "password"
    @admin.save
    post "/login", params: {name: @admin.username, password: @admin.password }
    
  end
  
  
end
