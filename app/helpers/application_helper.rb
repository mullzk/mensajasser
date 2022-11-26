# frozen_string_literal: true

module ApplicationHelper
  def short_date(date)
    date.strftime('%d.%m.%y')
  end

  def short_month(date)
    date.strftime('%B %Y')
  end

  def format_number(number)
    return unless number&.positive?

    if number.instance_of?(Integer)
      '%i' % number
    else
      '%.2f' % number
    end
  end

  def cyc_color_class
    raw "class=\"#{cyc_color}\""
  end

  def cyc_color
    cycle('color_silver', 'color_blue', 'color_green', 'color_yellow', 'color_red', name: 'colors')
  end

  def encrypted_mailto_link_for_adresses(array_of_mail_adresses)
    mail_adresses = encrypt_mails_adresses(array_of_mail_adresses.join(', '))
    "<a href='' data-js-decrypt-mailto-links='#{mail_adresses}' class='decent'>Mail an alle Jasser</a>"
  end

  private

  def encrypt_mails_adresses(string)
    string.gsub(/@/, '_AAA_').gsub(/\./, '_PPP_').gsub(/,/, '_KKK_').gsub(/ /, '_SSS_')
  end
end
