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
  

  def result_hash_for_jasser_in_date_range(jasser, from_date, to_date) 
    summed_up_results = Result.with_jasser(self).in_date_range(from_date, to_date).summed_up.first
    if summed_up_results.nil? then return {} end
    summed_up_results.attributes    
  end

  #######################################
  ### START OF OLD SMELLY CODE
  #######################################

  def result_stats(options={})
    from_date, to_date = parse_date_from_options(options)
    
    stat = result_hash_for_jasser_in_date_range(self, from_date, to_date)

    stat["jasser"] = self
    stat["id"]=id
    if stat["spiele"] && stat["spiele"] > 0
      stat["schnitt"] = stat["differenz"] / stat["spiele"].to_f
    else 
      stat["schnitt"] = nil
    end
    stat
  end
  


  def versenker_stats(options={})
    from_date, to_date = parse_date_from_options(options)
    
    stat = result_hash_for_jasser_in_date_range(self, from_date, to_date)


    stat["jasser"] = self
    if stat["spiele"] && stat["spiele"] > 0
      stat["roesi_ps"] = stat["roesi"] / stat["spiele"].to_f
      stat["droesi_ps"] = stat["droesi"] / stat["spiele"].to_f
      stat["versenkt_ps"] = stat["versenkt"] / stat["spiele"].to_f
    else 
      stat["roesi_ps"] = nil
       stat["roesi2_ps"] = nil
       stat["versenkt_ps"] = nil
    end
    if stat["roesi"] && stat["roesi"] > 0
      stat["roesi_quote"] = stat["droesi"].to_f / stat["roesi"].to_f
    else
      stat["roesi_quote"] = nil
    end
    stat
  end
  
  
  def self.jassers_having_results_in_time_interval(from_date, to_date)
    jasser_ids = Result.joins(:round)
                        .where("rounds.day >= ? AND rounds.day<= ?", from_date, to_date)
                        .select("jasser_id")
                        .group("jasser_id")
                        .collect {|result| result[:jasser_id]}
    Jasser.where("id IN (?)", jasser_ids)
  end
  
  
  #######################################
  ### END OF OLD SMELLY CODE
  #######################################  


  private
  
  def parse_date_from_options(options) 
    if options[:year] 
      from_date = options[:year].beginning_of_year
      to_date = options[:year].end_of_year
    elsif options[:month]
      from_date = options[:month].beginning_of_month
      to_date = options[:month].end_of_month
    elsif options[:day]
      from_date = options[:day]
      to_date = options[:day]
    elsif options[:to] && options[:from]
      from_date = options[:from]
      to_date = options[:to]
    else
      to_date ||= Date.today()
      from_date ||= to_date.beginning_of_year
    end
    
    raise "Expected a date on to_date, got something else" unless to_date.gregorian?
    raise "Expected a date on from_date, got something else" unless from_date.gregorian?
    
    [from_date, to_date]
  end
  
  
end
