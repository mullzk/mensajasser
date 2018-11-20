class GraphController < ApplicationController
  
  
  def year
    @page_specific_js_libraries = ["plotly"]
    @jasser_series = {} 
    Jasser.having_results_in_time_interval(Date.today.beginning_of_year, Date.today).each do |jasser|
      @jasser_series[jasser] = jasser.timeseries_for_year(Date.today)
    end    
  end

  def running
    @page_specific_js_libraries = ["plotly"]
    @timeseries = Jasser.find_by(name:"Mullzk").timeseries_running
  end

  def ewig
    @page_specific_js_libraries = ["plotly"]
    @jasser_series = {} 
    Jasser.having_results_in_time_interval(Date.today.beginning_of_year, Date.today).each do |jasser|
      @jasser_series[jasser] = jasser.timeseries_ewig
    end    
  end
end
