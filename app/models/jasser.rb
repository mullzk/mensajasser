# == Schema Information
#
# Table name: jassers
#
#  id              :bigint(8)        not null, primary key
#  active          :boolean          default(TRUE)
#  disqualifiziert :boolean
#  email           :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Jasser < ApplicationRecord
  has_many :results
  has_many :rounds, through: :results
  
  scope :valid, -> {where("disqualifiziert=false")}

  
  def self.having_results_in_time_interval(from_date, to_date)
    jasser_ids = Result.joins(:round)
                        .where("rounds.day >= ? AND rounds.day<= ?", from_date, to_date)
                        .select("jasser_id")
                        .group("jasser_id")
                        .collect {|result| result[:jasser_id]}
    Jasser.where("id IN (?)", jasser_ids)
  end
  

  
end
