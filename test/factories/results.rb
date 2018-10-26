# == Schema Information
#
# Table name: results
#
#  id         :bigint(8)        not null, primary key
#  chimiris   :integer          default(0), not null
#  differenz  :integer          not null
#  droesi     :integer          default(0), not null
#  gematcht   :integer          default(0), not null
#  huebimatch :integer          default(0), not null
#  max        :integer          default(0), not null
#  roesi      :integer          default(0), not null
#  spiele     :integer          not null
#  versenkt   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  jasser_id  :integer          not null
#  round_id   :integer          not null
#


FactoryBot.define do
  
  
end
