# frozen_string_literal: true

class ApplicationHelperTest < ActionView::TestCase
  test 'should return encrypted' do
    jasser1 = FactoryBot.create(:jasser, name: 'jasser1', email: 'info@test.ch', disqualifiziert: false)
    jasser2 = FactoryBot.create(:jasser, name: 'jasser2', email: 'mail_mit123_schnickschnack@TESs.co.uk',
                                         disqualifiziert: false)
    jasserinaktiv = FactoryBot.create(:jasser, name: 'jasser3', email: 'hallo@gmail.com', active: false,
                                               disqualifiziert: false)

    expected_string = 'info_AAA_test_PPP_ch_KKK__SSS_mail_mit123_schnickschnack_AAA_TESs_PPP_co_PPP_uk'

    @all_active_jassers_email = Jasser.where(active: true).map(&:email)
    encoded_string = encrypt_mails_adresses(@all_active_jassers_email.join(', '))
    assert_equal(encoded_string, expected_string, 'Encoded Mail Addresses was not as expected')

    assert_dom_equal(
      "<a href='' data-js-decrypt-mailto-links='#{expected_string}' class='decent'>Mail an alle Jasser</a>", encrypted_mailto_link_for_adresses(@all_active_jassers_email)
    )
  end
end
