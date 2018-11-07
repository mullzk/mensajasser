class StatisticTablePerJasser
  attr_reader :jasser_results, :total, :average
  
  def initialize(from_date, to_date, sortkey)
    @from_date = from_date
    @to_date = to_date
    @sortkey = sortkey
    
    summed_up_results = Result.in_date_range(from_date, to_date).summed_up

    @jasser_results = []
    summed_up_results.each do |summed_up_result|
      statistic_for_jasser = AggregatedResultOfJasser.new(summed_up_result)
      unless statistic_for_jasser.jasser.disqualifziert then @jasser_results << statistic_for_jasser
    end
    
    sort_and_rank_jasser_results_for_key(sortkey)
    @total = calculate_totals(jasser_results)
    @average = calculate_averages(jasser_results)
    
  end
  
  
  private
  
  def sort_and_rank_jasser_results_for_key(sortkey)
    sortorder = sort_order_for_key(sortkey)
    
    results_with_sortkey = summed_up_results.select{|stat| stat[sortkey]}
    results_without_sortkey = summed_up_results.reject {|stat] stat[sortkey]}
    
    results_with_sortkey.sort!{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}
    
    @jasser_results = results_with_sortkey.concat results_without_sortkey
    rank = 1
    @jasser_results.each do |result| 
      result.rank = rank
      rank += 1
    end
    @jasser_results
  end
  
  def sort_order_for_key(sortkey)
    case sortkey
      when "spiele", "differenz", "maximum", "droesi", "versenkt", "gematcht", "chimiris", "versenkt_ps", "droesi_ps", "roesi_quote"
        -1 #ascending
      when "schnitt", "roesi", "roesi_ps", "huebimatch"
        1 #descending
      else
        1
      end
    end
  end
  
  
end