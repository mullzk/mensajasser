# frozen_string_literal: true

require 'application_system_test_case'

class RoundsTest < ApplicationSystemTestCase
  setup do
    @round = FactoryBot.create(:round)
  end

  test 'visiting the index' do
    visit rounds_url
    assert_selector 'h1', text: 'Rounds'
  end

  test 'creating a Round' do
    visit rounds_url
    click_on 'New Round'

    click_on 'Create Round'

    assert_text 'Round was successfully created'
    click_on 'Back'
  end

  test 'updating a Round' do
    visit rounds_url
    click_on 'Edit', match: :first

    click_on 'Update Round'

    assert_text 'Round was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Round' do
    visit rounds_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Round was successfully destroyed'
  end
end
