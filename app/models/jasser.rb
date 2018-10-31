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
  has_many :rounds, :through => :results
  


  #######################################
  ### START OF OLD SMELLY CODE
  #######################################

  ##
  # Sums and maxes all Results of Jasser inside Timerange
  # @param [Hash] options The options hash.
  # @option options [Date] :to The last day where results are included for Computing. Defaults to today.
  # @option options [Date] :from The first day where results are included. Default to beginnen of :to's year.
  # @option options [Date] :day Set :to and :from to first and last day in month.
  # @option options [Date] :month Set :to and :from to first and last day in month.
  # @option options [Date] :year Set :to and :from to first and last day in year.
  # Precedence: Year, Month, day, To/From, Date.today().year
  def result_stats(options={})
    from_date, to_date = parse_date_from_options(options)
    
    results_in_period = Result.joins(:round)
                              .where("jasser_id = ? AND rounds.day >= ? AND rounds.day<= ?", self.id, from_date, to_date)                              
    if results_in_period.size == 0 then return {} end
    
    stat = results_in_period.select("sum(spiele) spiele, 
                                    sum(differenz) differenz, 
                                    max(max) maximum,
                                    sum(roesi) roesi, 
                                    sum(droesi) droesi, 
                                    sum(versenkt) versenkt, 
                                    sum(gematcht) gematcht, 
                                    sum(huebimatch) huebimatch, 
                                    sum(chimiris) chimiris")
                            .group("jasser_id")
                            .order("jasser_id")
                            .first
                            .attributes

    stat["jasser"] = self
    stat["id"]=id
    if stat["spiele"] && stat["spiele"] > 0
      stat["schnitt"] = stat["differenz"] / stat["spiele"].to_f
      stat["maximum"] = stat["maximum"].to_i
    else 
      stat["schnitt"] = nil
    end
    stat
  end
  


  def versenker_stats(options={})
    from_date, to_date = parse_date_from_options(options)
    
    results_in_period = Result.joins(:round)
                              .where("jasser_id = ? AND rounds.day >= ? AND rounds.day<= ?", self.id, from_date, to_date)
    if results_in_period.size == 0 then return {} end

    stat = results_in_period.select("sum(spiele) spiele, 
                                    sum(differenz) differenz, 
                                    max(max) maximum,
                                    sum(roesi) roesi, 
                                    sum(droesi) droesi, 
                                    sum(versenkt) versenkt, 
                                    sum(gematcht) gematcht, 
                                    sum(huebimatch) huebimatch, 
                                    sum(chimiris) chimiris")
                            .group("jasser_id")
                            .order("jasser_id")
                            .first
                            .attributes

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
  
  
  def self.with_results_in_time_interval(from_date, to_date)
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
