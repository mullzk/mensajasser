# frozen_string_literal: true

require "application_system_test_case"

class GraphsTest < ApplicationSystemTestCase
  setup do
    @jassers = FactoryBot.create_list(:uniquely_named_jasser, 4)
    create_round(@jassers)
  end

  # Regression for blank graphs when Turbo navigated into a page that needs
  # Plotly but the previous page had not loaded it.
  test "year graph renders after navigating from a page without plotly" do
    visit root_url
    click_on "Grafiken"
    click_on "Jahresschnitt"

    assert_selector "h1", text: "Graphische Jahresrangliste"
    assert_selector "#graph .main-svg"
  end

  test "running graph of a jasser renders when reached via the submenu" do
    visit root_url
    click_on "Grafiken"
    click_on "Laufender Schnitt"
    click_on @jassers.first.name

    assert_selector "#graph .main-svg"
  end
end
