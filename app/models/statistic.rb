

class Statistic
  
  def all_jassers_in_time_range_ordered_by(from_date, to_date, sortkey)
    results = Jasser.all.map do |jasser| 
      jasser.result_hash_for_date_range(from_date, to_date)
    end
    results.each do |result| calculate_derived_columns(result)
    # results.transform_values! do |result| calculate_derived_columns(result)
    results.select{|result| result[sortkey]}.sort{|a,b| sort_order_for_key(sortkey)*(a[sortkey]<=>b[sortkey])}
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