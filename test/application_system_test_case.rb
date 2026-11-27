# frozen_string_literal: true

require "test_helper"

# Chrome 158 rejects the wildcard origin Capybara 3.40.0 passes to
# Storage.clearDataForOrigin on every reset; see teamcapybara/capybara#2865.
# Drop this once a Capybara release fixes it.
module ClearStorageWithoutWildcardOrigin
  private

  def execute_cdp(cmd, params = {})
    return super unless cmd == "Storage.clearDataForOrigin" && params[:origin] == "*"

    types = params[:storageTypes].to_s.split(",")
    super("Network.clearBrowserCookies") if types.delete("cookies")

    origin = Capybara.current_session.server&.base_url
    super(cmd, params.merge(origin:, storageTypes: types.join(","))) if origin && types.any?
  end
end

if Gem.loaded_specs["capybara"].version == Gem::Version.new("3.40.0")
  Capybara::Selenium::Driver::ChromeDriver.prepend(ClearStorageWithoutWildcardOrigin)
end

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
