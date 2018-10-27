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
  belongs_to :round
  
  validates_numericality_of :spiele, :differenz, :roesi, :droesi, :versenkt, :gematcht, :huebimatch, :max, :chimiris
  validates_presence_of :spiele, :differenz, :jasser_id

  
  
  def schnitt
    if @spiele then @differenz/@spiele else 0 end
  end
  def schnitt=(schnitt)
    #noop
  end
  
  
  
  
  
  
  
  #######################################
  ### START OF OLD SMELLY CODE
  #######################################


  #######################################
  ### END OF OLD SMELLY CODE
  #######################################  
end
