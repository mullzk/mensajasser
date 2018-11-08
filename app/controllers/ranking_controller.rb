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

    @columns = {spiele: "Spiele", differenz: "Differenz", schnitt: "Schnitt", max: "Max", roesi: "Rösi", droesi: "2xRösi", versenkt: "Versenkt", gematcht: "Match", huebimatch: "H.Match", chimiris: "Dähler-Ris"}
    @statistic_table = StatisticTablePerJasser.new(@date, @date, "schnitt")
        
    #Calcultating Rangverschiebung (big magic inside round.rb)
    @rangverschiebung = Round.calculate_rangeverschiebungs_table(@date)
  end




  private
  
  def permit_sort_key(suggested_key)
    if ["spiele", "differenz", "max", "droesi", "versenkt", "gematcht", "chimiris", "schnitt", "roesi", "huebimatch", "versenkt_pro_spiel", "roesi_pro_spiel", "droesi_pro_spiel", "roesi_quote"].include?(suggested_key) then
      suggested_key
    else # if no permitted sortkey is provided, sort by schnitt
      "schnitt"
    end
  end

  
  
  def parse_day_param(param)
    if param
      begin
        date = Date.parse(param)
      rescue 
        #Do nothing, we will use current date a few more lines down
      end
      begin 
        date ||= Date.new(param.to_i)
      rescue
        #Do nothing, we will use current date a few more lines down
      end
    end
    date ||= Date.today
    unless date.gregorian?
      date = Date.today
    end
    date
  end
  

end
