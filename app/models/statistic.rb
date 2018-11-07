

class Statistic
  attr_accessor :single_lines, :total_line, :avg_line
  
  def initialize
    @single_lines = []
    @total_line = {}
    @avg_line = {}
  end
  
  def all_jassers_in_time_range_ordered_by(from_date, to_date, sortkey)
    @single_lines = Jasser.all.map do |jasser| 
      jasser.result_hash_for_date_range(from_date, to_date)
    end
    @single_lines.each do |single_line| amend_single_line_with_derived_columns(single_line)
    @single_lines.select{|single_line| single_line[sortkey]}.sort{|a,b| sort_order_for_key(sortkey)*(a[sortkey]<=>b[sortkey])}
  end
  
  
  
  
  
  private
  
  def amend_single_line_with_derived_columns(result)
    if result["spiele"] && result["spiele"] > 0
       result["schnitt"] = result["differenz"] / result["spiele"].to_f
       result["roesi_ps"] = result["roesi"] / result["spiele"].to_f
       result["droesi_ps"] = result["droesi"] / result["spiele"].to_f
       result["versenkt_ps"] = result["versenkt"] / result["spiele"].to_f
    else 
       result["schnitt"] = nil
       result["roesi_ps"] = nil
       result["roesi2_ps"] = nil
       result["versenkt_ps"] = nil
    end
    if result["roesi"] && result["roesi"] > 0
      result["roesi_quote"] = result["droesi"].to_f / result["roesi"].to_f
    else
      result["roesi_quote"] = nil
    end
  end

  def calculate_total_line
    for col in @single_lines.first
      @total_line[col] = @single_lines.inject(0) do |col_total, single_line| 
        unless single_line[col].nil? then 
          col_total += single_line[col] 
        else 
          col_total 
        end 
      end
    end
    # Maximum of all Jassers / Months cannot be summed up
    unless @total_line["maximum"].nil?
      @total_line["maximum"] = @single_lines.inject(0) { |total_max, single_line| [total_max, single_line["maximum"]].max }
    end      
    # Total of Schnitt of all Jassers does not make any sense
    unless @total_line["schnitt"].nil?
      @total_line["schnitt"] = ""
    end      
  end
  
  def calculate_average_line
    if @total_line["spiele"] && @total_line["spiele"] > 0
      for col in @total_line
        @average_line[col] = @total_line[col]/@total_line["spiele"].to_f
      end
    end
    # Average of Maximum does not make any sense
    unless @total_line["maximum"].nil?
      @total_line["maximum"] = ""
    end          
  end

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