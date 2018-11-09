class BersekerStatisticTable
  attr_reader :jasser_results
  
  def initialize(from_date, to_date, sortkey)
    @from_date = from_date
    @to_date = to_date
    @sortkey = sortkey
    
    @jasser = Jasser.having_results_in_time_interval(from_date, to_date)
    
    @jasser_stats = {}
    @jasser.each do |jasser|
      @jasser_stats[jasser] = {}
      @jasser_stats[jasser][:jasser] = jasser
      @jasser_stats[jasser][:spiele] = 0
      @jasser_stats[jasser][:eigene_differenz] = 0
      @jasser_stats[jasser][:tisch_differenz] = 0
    end

    Round.in_date_range(from_date, to_date).each do |round| 
      tisch_differenz = round.results.inject(0) {|acc,result| acc+=result.differenz} 
      round.results.each do |result| 
        
        @jasser_stats[result.jasser][:spiele] += result.spiele
        @jasser_stats[result.jasser][:eigene_differenz] += result.differenz
        @jasser_stats[result.jasser][:tisch_differenz] += tisch_differenz
      end
    end
    
    @jasser_results = @jasser_stats.map do |key,value|
      result = {}

      result[:jasser] = value[:jasser]
      result[:spiele] = value[:spiele]
      result[:eigene_differenz] = value[:eigene_differenz]
      result[:tisch_differenz]  = value[:tisch_differenz]
      
      result[:eigener_schnitt]  = result[:eigene_differenz]/result[:spiele].to_f
      result[:tisch_schnitt]    = result[:tisch_differenz]/4.0/result[:spiele].to_f
      result[:gegner_schnitt]   = (result[:tisch_differenz]-result[:eigene_differenz])/3.0/result[:spiele].to_f 
      result[:schaedling_index] = result[:gegner_schnitt]/result[:eigener_schnitt]  
      result
    end
      
    if @jasser_results && @jasser_results.size > 0 then
      sort_and_rank_jasser_results_for_key(@sortkey)
    end
      
  end
  
  
  private
  
  
  def sort_and_rank_jasser_results_for_key(sortkey)
    sortorder = sort_order_for_key(sortkey)
    
    if @jasser_results && @jasser_results.size > 0 && @jasser_results[0][sortkey] then
      results_with_sortkey = @jasser_results.select{|stat| stat[sortkey]}
      results_without_sortkey = @jasser_results.reject {|stat| stat[sortkey]}
    
      results_with_sortkey.sort!{|a,b| sortorder*(a[sortkey]<=>b[sortkey])}
    
      @jasser_results = results_with_sortkey.concat results_without_sortkey
      rank = 1
      @jasser_results.each do |result| 
        result[:rank] = rank
        rank += 1
      end
      @jasser_results
    else
      raise "Trying to sort results with an invalid Sortkey: #{sortkey}"
    end
    
  end
  

  def sort_order_for_key(sortkey)
    case sortkey
      when :spiele, :gegner_schnitt, :schaedling_index
        -1 #ascending
      when :eigener_schnitt
        1 #descending
      else
        1
    end
  end
  
  
end