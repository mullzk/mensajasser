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

FactoryBot.define do
  factory :result do
    differenz { 200 }
    spiele { 20 }
  end
end
