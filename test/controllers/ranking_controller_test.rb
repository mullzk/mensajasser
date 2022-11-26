# frozen_string_literal: true

require 'test_helper'

class RankingControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_jassers_rounds_and_results
  end

  test 'should get year_ranking' do
    get url_for controller: 'ranking', action: 'year', date: '2018'
    assert_response :success
    get '/ranking/year/2017-11-09'
    assert_response :success
    get '/ranking/year/2016'
    assert_response :success
  end

  test 'should get month_ranking' do
    get url_for controller: 'ranking', action: 'month'
    assert_response :success
  end

  test 'should get versenker_ranking' do
    get url_for controller: 'ranking', action: 'versenker_und_roesis', date: '2016'
    assert_response :success
  end

  test 'should get 12-months-ranking' do
    get url_for controller: 'ranking', action: 'last_12_months', date: '2017-11-09'
    assert_response :success
  end

  test 'should get 3-months-ranking' do
    get url_for controller: 'ranking', action: 'last_3_months'
    assert_response :success
  end

  test 'should get Ewige Rangliste' do
    get url_for controller: 'ranking', action: 'ewig'
    assert_response :success
  end

  test 'should get Ranking for day' do
    get url_for controller: 'ranking', action: 'day'
    assert_response :success
    get url_for controller: 'ranking', action: 'day', date: @d2017_jan_21
    assert_response :success
    get url_for controller: 'ranking', action: 'day', date: @d2017_jan_20 # there is only a round for Jan 20th, but no previous round
    assert_response :success
    get url_for controller: 'ranking', action: 'day', date: Date.new(2016, 1, 5) # no rounds setup for 2016 or earlier
    assert_response :success
    get url_for controller: 'ranking', action: 'day', date: @d2017_jan_23 # Jasser5 has his first game, should lead to changes on green table
    assert_response :success
  end

  test 'should get Berseker-Table' do
    get url_for controller: 'ranking', action: 'berseker'
    assert_response :success
    get url_for controller: 'ranking', action: 'berseker', date: @d2017_jan_21
    assert_response :success
    get url_for controller: 'ranking', action: 'berseker', date: Date.new(1980, 1, 5) # no rounds setup for 2016 or earlier
    assert_response :success
  end

  test 'should get Angstgegner-Table' do
    get url_for controller: 'ranking', action: 'angstgegner', id: @j1.id
    assert_response :success
    get url_for controller: 'ranking', action: 'angstgegner', id: 'keineid'
    assert_redirected_to '/ranking#year'
  end

  private

  def setup_jassers_rounds_and_results
    @d2017_start = Date.new(2017, 1, 1)
    @d2017_end   = Date.new(2017, 12, 31)
    @d2018_start = Date.new(2018, 1, 1)
    @d2018_end   = Date.new(2018, 12, 31)

    @d2017_jan_start = Date.new(2017, 1, 1)
    @d2017_jan_end   = Date.new(2017, 12, 31)
    @d2018_jan_start = Date.new(2018, 1, 1)
    @d2018_jan_end   = Date.new(2018, 1, 31)
    @d2018_mar_start = Date.new(2018, 3, 1)
    @d2018_mar_end   = Date.new(2018, 3, 31)

    @d2017_jan_20   = Date.new(2017, 1, 20)
    @d2017_jan_21   = Date.new(2017, 1, 21)
    @d2017_jan_22   = Date.new(2017, 1, 22)

    @d2018_jan_20   = Date.new(2018, 1, 20)
    @d2018_jan_21   = Date.new(2018, 1, 21)
    @d2018_jan_22   = Date.new(2018, 1, 22)

    @d2018_mar_20   = Date.new(2018, 3, 20)
    @d2018_mar_21   = Date.new(2018, 3, 21)

    @j1 = FactoryBot.create(:jasser, name: 'jasser1')
    @j2 = FactoryBot.create(:jasser, name: 'jasser2')
    @j3 = FactoryBot.create(:jasser, name: 'jasser3')
    @j4 = FactoryBot.create(:jasser, name: 'jasser4')
    @j5 = FactoryBot.create(:jasser, name: 'jasser5')
    @j6 = FactoryBot.create(:jasser, name: 'jasser6')
    @j7 = FactoryBot.create(:jasser, name: 'jasser7')
    @j8 = FactoryBot.create(:jasser, name: 'jasser8')

    @t1 = FactoryBot.create(:round, day: @d2017_jan_20)
    @t2 = FactoryBot.create(:round, day: @d2017_jan_21)
    @t3 = FactoryBot.create(:round, day: @d2017_jan_22)
    @t4 = FactoryBot.create(:round, day: @d2018_jan_20)
    @t5 = FactoryBot.create(:round, day: @d2018_jan_21)
    @t6 = FactoryBot.create(:round, day: @d2018_jan_22)
    @t7 = FactoryBot.create(:round, day: @d2018_mar_20)
    @t8 = FactoryBot.create(:round, day: @d2018_mar_21)
    @t9 = FactoryBot.create(:round, day: @d2018_mar_21)

    # 2017 January
    FactoryBot.create(:result, round_id: @t1.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 20, roesi: 4, droesi: 4,
                               versenkt: 2, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t1.id, jasser_id: @j2.id, spiele: 10, differenz: 200, max: 30, roesi: 2, droesi: 3,
                               versenkt: 1, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t1.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 40, roesi: 3, droesi: 1,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t1.id, jasser_id: @j4.id, spiele: 10, differenz: 110, max: 50, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 1, huebimatch: 1, chimiris: 1)

    FactoryBot.create(:result, round_id: @t2.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 25, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t2.id, jasser_id: @j2.id, spiele: 10, differenz: 200, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t2.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t2.id, jasser_id: @j4.id, spiele: 10, differenz: 110, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    FactoryBot.create(:result, round_id: @t3.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 30, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t3.id, jasser_id: @j2.id, spiele: 10, differenz: 200, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t3.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t3.id, jasser_id: @j5.id, spiele: 10, differenz: 140, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    # 2018 January
    FactoryBot.create(:result, round_id: @t4.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 25, roesi: 3, droesi: 4,
                               versenkt: 2, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t4.id, jasser_id: @j2.id, spiele: 10, differenz: 110, max: 35, roesi: 0, droesi: 2,
                               versenkt: 1, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t4.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 40, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t4.id, jasser_id: @j4.id, spiele: 10, differenz: 130, max: 50, roesi: 2, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    FactoryBot.create(:result, round_id: @t5.id, jasser_id: @j1.id, spiele: 20, differenz: 300, max: 40, roesi: 3, droesi: 4,
                               versenkt: 2, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t5.id, jasser_id: @j2.id, spiele: 20, differenz: 310, max: 50, roesi: 0, droesi: 2,
                               versenkt: 1, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t5.id, jasser_id: @j3.id, spiele: 20, differenz: 320, max: 60, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t5.id, jasser_id: @j5.id, spiele: 20, differenz: 330, max: 70, roesi: 2, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    FactoryBot.create(:result, round_id: @t6.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t6.id, jasser_id: @j2.id, spiele: 10, differenz: 110, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t6.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t6.id, jasser_id: @j6.id, spiele: 10, differenz: 130, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    # 2018 March
    FactoryBot.create(:result, round_id: @t7.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t7.id, jasser_id: @j2.id, spiele: 10, differenz: 110, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t7.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t7.id, jasser_id: @j4.id, spiele: 10, differenz: 130, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    FactoryBot.create(:result, round_id: @t8.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t8.id, jasser_id: @j2.id, spiele: 10, differenz: 110, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t8.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t8.id, jasser_id: @j5.id, spiele: 10, differenz: 130, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)

    FactoryBot.create(:result, round_id: @t9.id, jasser_id: @j1.id, spiele: 10, differenz: 100, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t9.id, jasser_id: @j2.id, spiele: 10, differenz: 110, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t9.id, jasser_id: @j3.id, spiele: 10, differenz: 120, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
    FactoryBot.create(:result, round_id: @t9.id, jasser_id: @j7.id, spiele: 10, differenz: 130, max: 20, roesi: 0, droesi: 0,
                               versenkt: 0, gematcht: 0, huebimatch: 0, chimiris: 0)
  end
end
