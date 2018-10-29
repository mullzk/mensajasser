class ApplicationController < ActionController::Base


  protect_from_forgery 

  helper :all # include all helpers, all the time
  

  private
  
  def initialize
    @last_entered_round = Round.order(created_at: :desc).first
    super
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
  
  def authorize
    unless User.find_by_id(session[:user_id]) || User.count.zero?
      flash[:notice] = "Bitte einloggen"
      redirect_to :controller => "users", :action => "login"
    end
  end
  
end
