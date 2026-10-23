# frozen_string_literal: true

require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  setup do
    @jassers = FactoryBot.create_list(:uniquely_named_jasser, 4)
    create_round(@jassers)
  end

  test "dropdown opens and its links navigate" do
    visit root_url
    assert_no_link "Monats-Rangliste"

    click_on "Haupt-Ranglisten"
    click_on "Monats-Rangliste"

    assert_current_path "/ranking/month"
  end

  test "opening a dropdown closes the other one" do
    visit root_url
    click_on "Haupt-Ranglisten"
    assert_link "Monats-Rangliste"

    click_on "Spezial-Listen"

    assert_link "Schlimmste Runden"
    assert_no_link "Monats-Rangliste"
  end

  test "dropdowns still work after a turbo navigation" do
    visit root_url
    click_on "Haupt-Ranglisten"
    click_on "Ewige Rangliste"
    assert_current_path "/ranking/ewig"

    click_on "Spezial-Listen"
    click_on "Schlimmste Runden"

    assert_current_path "/ranking/schlimmstespiele"
  end

  test "submenu opens and its links navigate" do
    jasser = @jassers.first
    visit root_url
    click_on "Spezial-Listen"
    assert_no_link jasser.name

    click_on "Angstgegner"
    click_on jasser.name

    assert_current_path "/ranking/angstgegner/#{jasser.id}"
  end

  test "admin menu shows the admin links once signed in" do
    visit root_url
    click_on "Admin"
    assert_link "Login"
    assert_no_link "Neues Tableau"

    sign_in
    click_on "Admin"

    assert_link "Neues Tableau"
    assert_link "Logout"
  end

  test "navbar toggler reveals the collapsed menu on narrow screens" do
    page.current_window.resize_to(400, 800)
    visit root_url
    assert_no_link "Haupt-Ranglisten"

    find(".navbar-toggler").click
    click_on "Haupt-Ranglisten"
    click_on "Quartals-Ranking"

    assert_current_path "/ranking/last_3_months"
  ensure
    page.current_window.resize_to(1400, 1400)
  end
end
