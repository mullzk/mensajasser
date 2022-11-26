require 'application_system_test_case'

class JassersTest < ApplicationSystemTestCase
  setup do
    @jasser = FactorBot.create(:jasser)
  end

  test 'visiting the index' do
    visit jassers_url
    assert_selector 'h1', text: 'Jassers'
  end

  test 'creating a Jasser' do
    visit jassers_url
    click_on 'New Jasser'

    click_on 'Create Jasser'

    assert_text 'Jasser was successfully created'
    click_on 'Back'
  end

  test 'updating a Jasser' do
    visit jassers_url
    click_on 'Edit', match: :first

    click_on 'Update Jasser'

    assert_text 'Jasser was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Jasser' do
    visit jassers_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Jasser was successfully destroyed'
  end
end
