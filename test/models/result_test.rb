# frozen_string_literal: true

# == Schema Information
#
# Table name: results
#
#  id         :integer          not null, primary key
#  round_id   :integer          not null
#  jasser_id  :integer          not null
#  spiele     :integer          not null
#  differenz  :integer          not null
#  roesi      :integer          default("0"), not null
#  droesi     :integer          default("0"), not null
#  versenkt   :integer          default("0"), not null
#  gematcht   :integer          default("0"), not null
#  huebimatch :integer          default("0"), not null
#  max        :integer          default("0"), not null
#  chimiris   :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
