# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_round, only: %i[show edit update destroy]
  before_action :authorize, except: %i[index show]

  # GET /rounds
  def index
    @user_is_authorized = User.find_by(id: session[:user_id]) ? true : false
    @rounds = Round.order('day desc').page(params[:page])
  end

  # GET /rounds/1
  def show; end

  # GET /rounds/new
  def new
    @round = Round.new
    @round.creator = User.find_by(id: session[:user_id]).username
    4.times { @round.results.build }
    @jassers = Jasser.where(active: true).sort { |a, b| a.name <=> b.name }
  end

  # GET /rounds/1/edit
  def edit
    @jassers = Jasser.where(active: true).sort { |a, b| a.name <=> b.name }
    @round = Round.find(params[:id])
  end

  # POST /rounds
  def create
    @round = Round.new(round_params)
    @jassers = Jasser.where(active: true).sort { |a, b| a.name <=> b.name }
    if @round.save
      redirect_to controller: 'ranking', action: 'day', date: @round.day
    else
      render :new
    end
  end

  # PATCH/PUT /rounds/1
  def update
    if @round.update(round_params)
      redirect_to @round, notice: 'Round was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /rounds/1
  def destroy
    @round.destroy
    redirect_to rounds_url, notice: 'Round was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_round
    @round = Round.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def round_params
    params.fetch(:round, {}).permit(:comment, :creator, :day, :results,
                                    results_attributes: %i[jasser_id spiele differenz max roesi droesi versenkt gematcht huebimatch chimiris id])
  end
end
