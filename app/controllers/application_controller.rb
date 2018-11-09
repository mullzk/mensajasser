class ApplicationController < ActionController::Base


  protect_from_forgery 

  helper :all # include all helpers, all the time
  

  private
  
  def initialize
    @last_entered_round = Round.order(created_at: :desc).first
    super
  end
    
  
  def authorize
    if (session[:user_id].nil? || User.find_by(id: session[:user_id].nil?) && User.count > 0)
      flash[:notice] = "Bitte einloggen"
      redirect_to :controller => "users", :action => "login"
    end
  end
  
end
