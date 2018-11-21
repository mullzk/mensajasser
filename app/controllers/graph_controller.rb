class GraphController < ApplicationController
  
  
  def year
    @date = parse_day_param(params[:date])
    @page_specific_js_libraries = ["plotly"]
    @jasser_series = {} 
    Jasser.having_results_in_time_interval(Date.today.beginning_of_year, Date.today).each do |jasser|
      @jasser_series[jasser] = jasser.timeseries_for_year(@date)
    end    
  end

  def running
    @page_specific_js_libraries = ["plotly"]
    begin
      @jasser = Jasser.find(params[:id])
    rescue
      redirect_to "/graph/year", notice: "User for id #{params[:id]} could not be found" and return
    end
    @timeseries = @jasser.timeseries_running
  end

  def ewig
    @page_specific_js_libraries = ["plotly"]
    begin
      @jasser = Jasser.find(params[:id])
    rescue
      redirect_to "/graph/year", notice: "User for id #{params[:id]} could not be found" and return
    end
    @timeseries = @jasser.timeseries_ewig

  end
  
  
  
  
  def parse_day_param(param)
    if param
      begin
        date = Date.parse(param)
      rescue 
        #Do nothing, we will use current date a few more lines down
      end
      begin 
        date ||= Date.new(param.to_i).end_of_year
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
