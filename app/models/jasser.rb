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
    if options[:year] 
      options[:from] = options[:year].beginning_of_year
      options[:to] = options[:year].end_of_year
    elsif options[:month]
      options[:from] = options[:month].beginning_of_month
      options[:to] = options[:month].end_of_month
    elsif options[:day]
      options[:from] = options[:day]
      options[:to] = options[:day]
    else
      options[:to] ||= Date.today()
      options[:from] ||= options[:to].beginning_of_year
    end
    
    raise "Expected a date, got something else" unless options[:to].gregorian?
    raise "Expected a date, got something else" unless options[:from].gregorian?
    
    stat = Result.where("jasser_id = ? AND rounds.day >= ? AND rounds.day<= ?", self.id, options[:from], options[:to] ).select("sum(spiele) spiele, 
                                        sum(differenz) differenz, 
                                        max(max) maximum,
                                        sum(roesi) roesi, 
                                        sum(droesi) droesi, 
                                        sum(versenkt) versenkt, 
                                        sum(gematcht) d_gematcht, 
                                        sum(huebimatch) huebimatch, 
                                        sum(chimiris) chimiris").joins(:round).order("sum(differenz)")
    stat = stat.first.attributes
    
    stat["jasser"] = self
    if stat["spiele"] && stat["spiele"] > 0
      stat["schnitt"] = stat["differenz"] / stat["spiele"].to_f
      stat["maximum"] = stat["maximum"].to_i
    else 
      stat["schnitt"] = nil
    end
    stat
  end
  


  def versenker_stats(options={})
    if options[:year] 
      options[:from] = options[:year].beginning_of_year
      options[:to] = options[:year].end_of_year
    elsif options[:month]
      options[:from] = options[:month].beginning_of_month
      options[:to] = options[:month].end_of_month
    elsif options[:day]
      options[:from] = options[:day]
      options[:to] = options[:day]
    else
      options[:to] ||= Date.today()
      options[:from] ||= options[:to].beginning_of_year
    end
    
    raise "Expected a date, got something else" unless options[:to].gregorian?
    raise "Expected a date, got something else" unless options[:from].gregorian?
    

    stat = Result.where("jasser_id = ? AND rounds.day >= ? AND rounds.day<= ?", self.id, options[:from], options[:to] ).select("sum(spiele) spiele, 
                                        sum(differenz) differenz, 
                                        max(max) maximum,
                                        sum(roesi) roesi, 
                                        sum(droesi) droesi, 
                                        sum(versenkt) versenkt, 
                                        sum(gematcht) gematcht, 
                                        sum(huebimatch) huebimatch, 
                                        sum(chimiris) chimiris").joins(:round).order("sum(differenz)")
    stat = stat.first.attributes

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
  #######################################
  ### END OF OLD SMELLY CODE
  #######################################  

end
