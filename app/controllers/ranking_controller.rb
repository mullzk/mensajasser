class RankingController < ApplicationController

  def year
    @date = parse_day_param(params[:date])
    sortkey, sortorder = parse_sort_params
    @ranking = Jasser.all.map{|jasser| jasser.result_stats(:year => @date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}

    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
  end

  def month
    @date = parse_day_param(params[:date])
    sortkey, sortorder = parse_sort_params
    @ranking = Jasser.all.map{|jasser| jasser.result_stats(:month => @date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}

    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
  end
  
  def versenker_und_roesis
    @date = parse_day_param(params[:date])
    sortkey, sortorder = parse_sort_params_versenker
    @ranking = Jasser.all.map{|jasser| jasser.versenker_stats(:year => @date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}

    @rank = 0.0
  end

  def last_12_months
    @date = parse_day_param(params[:date])
    @from_date = @date - 1.year
    sortkey, sortorder = parse_sort_params
    @ranking = Jasser.all.map{|jasser| jasser.result_stats(:to => @date, :from => @from_date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}

    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
  end

  def last_3_months
    @date = parse_day_param(params[:date])
    @from_date = @date - 3.months
    sortkey, sortorder = parse_sort_params
    @ranking = Jasser.all.map{|jasser| jasser.result_stats(:to => @date, :from => @from_date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}

    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
  end


  def ewig
    sortkey, sortorder = parse_sort_params
    @ranking = Jasser.where(disqualifiziert: false).map{|jasser| jasser.result_stats(:from => Round.minimum("day"), :to => Round.maximum("day"))}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}

    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
  end


  def day
    @date = parse_day_param(params[:date])
    @rounds = Round.where("day = ?", @date)
    if @rounds.empty?
      @date = Round.order(created_at: :desc).first.day
      @rounds = Round.where("day = ?", @date)
    end

    #Calculating Tagesstatistik
    sortkey, sortorder = parse_sort_params
    jasser_of_the_day = @rounds.collect{|x|x.jassers}.flatten.uniq
    @ranking = jasser_of_the_day.map{|jasser| jasser.result_stats(:day => @date)}.select{|stat| stat[sortkey]}.sort{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}
    @rank = 0.0
    @additional_columns = %w(roesi droesi versenkt gematcht huebimatch chimiris)
    @totals = calculate_total(@ranking, @additional_columns)
    
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

end
