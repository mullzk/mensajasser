# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all # include all helpers, all the time
  layout 'mensajasser'

  private

  def initialize
    @last_entered_round = Round.order(created_at: :desc).first
    @all_active_jassers_email = Jasser.where(active: true).map(&:email)
    super
  end

  def authorize
    return unless session[:user_id].nil? || User.find_by(id: session[:user_id].nil?) && User.count.positive?

    flash[:notice] = 'Bitte einloggen'
    redirect_to controller: 'users', action: 'login'
  end
end
