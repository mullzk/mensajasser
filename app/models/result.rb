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

class Result < ApplicationRecord
  belongs_to :jasser
  belongs_to :round, inverse_of: :results
  
  validates_numericality_of :spiele, :differenz, :roesi, :droesi, :versenkt, :gematcht, :huebimatch, :max, :chimiris
  validates_presence_of :spiele, :differenz, :jasser_id

  scope :in_date_range, ->(from_date, to_date)  { joins(:round).where("rounds.day >= ? AND rounds.day<= ?", from_date, to_date) }
  scope :with_jasser, ->(jasser) {where("jasser_id=?", jasser.id)}
  scope :summed_up, ->{ select("jasser_id, sum(spiele) spiele, 
                                    sum(differenz) differenz, 
                                    max(max) maximum,
                                    sum(roesi) roesi, 
                                    sum(droesi) droesi, 
                                    sum(versenkt) versenkt, 
                                    sum(gematcht) gematcht, 
                                    sum(huebimatch) huebimatch, 
                                    sum(chimiris) chimiris").group("jasser_id").order("jasser_id") }

  
  def schnitt
    if @spiele then @differenz/@spiele else 0 end
  end
  def schnitt=(schnitt)
    #noop
  end
  

  
end
