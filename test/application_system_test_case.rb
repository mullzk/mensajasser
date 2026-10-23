# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  def sign_in
    FactoryBot.create(:user, username: "admin", password: "password")
    visit login_url
    fill_in "name", with: "admin"
    fill_in "password", with: "password"
    click_on "Login"
    assert_selector "h1", text: "Neues Tableau"
  end

  def create_round(jassers, day: Date.today)
    round = Round.new(day:)
    jassers.each_with_index do |jasser, i|
      round.results.build(jasser:, spiele: 20, differenz: 100 * (i + 1))
    end
    round.save!
    round
  end
end
