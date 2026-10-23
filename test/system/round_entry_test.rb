# frozen_string_literal: true

require "application_system_test_case"

class RoundEntryTest < ApplicationSystemTestCase
  setup do
    @jassers = FactoryBot.create_list(:uniquely_named_jasser, 4)
    sign_in
  end

  test "entering a tableau copies the number of games to all rows and saves it" do
    @jassers.each_with_index do |jasser, i|
      select jasser.name, from: "round_results_attributes_#{i}_jasser_id"
    end
    fill_in "round_results_attributes_0_spiele", with: "24"
    fill_in "round_results_attributes_0_differenz", with: "150"

    1.upto(3) do |i|
      assert_field "round_results_attributes_#{i}_spiele", with: "24"
      fill_in "round_results_attributes_#{i}_differenz", with: (150 + (i * 50)).to_s
    end
    click_on "Create Round"

    assert_selector "h1", text: "Die Jasserei am"
    round = Round.last
    assert_equal @jassers.map(&:id).sort, round.results.map(&:jasser_id).sort
    assert_equal [ 24 ], round.results.map(&:spiele).uniq
  end
end
