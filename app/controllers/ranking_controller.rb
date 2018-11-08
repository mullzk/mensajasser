class RankingController < ApplicationController

  def year
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new(@date.beginning_of_year, @date.end_of_year, sortkey)
  end

  def month
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new(@date.beginning_of_month, @date.end_of_month, sortkey)
  end
  
  def versenker_und_roesis
    @date = parse_day_param(params[:date])
    params[:order] ||= "versenkt_pro_spiel"
    sortkey = permit_sort_key(params[:order])
    @columns = {spiele: "Spiele", versenkt: "Versenkt", versenkt_pro_spiel: "Versenker p.Spiel", roesi: "Rösi", roesi_pro_spiel: "Rösi p.Spiel", droesi: "2xRösi", droesi_pro_spiel: "2xRösi p.Spiel", roesi_quote: "Rösi-Quote"}
    @statistic_table = StatisticTablePerJasser.new(@date.beginning_of_year, @date.end_of_year, sortkey)
  end

  def last_12_months
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new((@date - 1.year), @date, sortkey)
  end

  def last_3_months
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new((@date - 3.months), @date, sortkey)
  end


  def ewig
    sortkey = permit_sort_key(params[:order])
    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new(Date.new(1980,1,1), Date.today, sortkey)
  end


  def day
    @date = parse_day_param(params[:date])
    @rounds = Round.where("day = ?", @date)
    if @rounds.empty?
      @date = Round.order(created_at: :desc).first.day
      @rounds = Round.where("day = ?", @date)
    end

    #Calculating Tagesstatistik
=begin
    sortkey, sortorder = parse_sort_params
    jasser_of_the_day = @rounds.collect{|x|x.jassers}.flatten.uniq
    @ranking = jasser_of_the_day.map{|jasser| jasser.result_stats(:day => @date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}
    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
=end
    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new(@date, @date, "schnitt")
    
        
    #Calcultating Rangverschiebung (big magic inside round.rb)
    @rangverschiebung = Round.calculate_rangeverschiebungs_table(@date)
  end


  private
  

  def calculate_total(ranking, additional_columns)
    totals = {}
    totals["spiele"]    = ranking.inject(0) {|acc, jasser| acc += jasser["spiele"]}
    totals["differenz"] = ranking.inject(0) {|acc, jasser| acc += jasser["differenz"]} 
    totals["maximum"]   = ranking.inject(0) {|acc, jasser| if acc > jasser["maximum"].to_i then acc else jasser["maximum"].to_i end }
    #the following columns look all the same, so we can can avoid repeating...
    for col in additional_columns
      totals[col] = ranking.inject(0){|acc, jasser| unless jasser[col].nil? then acc += jasser[col] else acc end
      }
    end
    totals
  end
  
  def parse_sort_params
    if params[:order]
      case params[:order]
      when "spiele", "differenz", "maximum", "droesi", "versenkt", "gematcht", "chimiris"
        [params[:order], -1]
      when "schnitt", "roesi", "huebimatch"
        [params[:order], 1]
      else
        ["schnitt", 1]
      end
    else
      ["schnitt", 1]
    end
  end

  def parse_sort_params_versenker
    if params[:order]
      case params[:order]
      when "versenkt", "versenkt_ps", "droesi", "droesi_ps", "roesi_quote", "spiele"
        [params[:order], -1]
      when "roesi", "roesi_ps"
        [params[:order], 1]
      else
        ["versenkt_ps", -1]
      end
    else
      ["versenkt_ps", -1]
    end
  end
  
  def permit_sort_key(suggested_key)
    if ["spiele", "differenz", "max", "droesi", "versenkt", "gematcht", "chimiris", "schnitt", "roesi", "huebimatch", "versenkt_pro_spiel", "roesi_pro_spiel", "droesi_pro_spiel", "roesi_quote"].include?(suggested_key) then
      suggested_key
    else # if no permitted sortkey is provided, sort by schnitt
      "schnitt"
    end
  end

end
