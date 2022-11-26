# frozen_string_literal: true

class RankingController < ApplicationController
  def year
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = { spiele: 'Spiele', differenz: 'Differenz', schnitt: 'Schnitt', max: 'Max', roesi: 'Rösi',
                 droesi: '2xRösi', versenkt: 'Versenkt', gematcht: 'Match', huebimatch: 'H.Match', chimiris: 'Dähler-Ris' }
    @statistic_table = StatisticTablePerJasser.new(@date.beginning_of_year, @date.end_of_year, sortkey)
  end

  def month
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = { spiele: 'Spiele', differenz: 'Differenz', schnitt: 'Schnitt', max: 'Max', roesi: 'Rösi',
                 droesi: '2xRösi', versenkt: 'Versenkt', gematcht: 'Match', huebimatch: 'H.Match', chimiris: 'Dähler-Ris' }
    @statistic_table = StatisticTablePerJasser.new(@date.beginning_of_month, @date.end_of_month, sortkey)
  end

  def versenker_und_roesis
    @date = parse_day_param(params[:date])
    params[:order] ||= 'versenkt_pro_spiel'
    sortkey = permit_sort_key(params[:order])
    @columns = { spiele: 'Spiele', versenkt: 'Versenkt', versenkt_pro_spiel: 'Versenker p.Spiel', roesi: 'Rösi',
                 roesi_pro_spiel: 'Rösi p.Spiel', droesi: '2xRösi', droesi_pro_spiel: '2xRösi p.Spiel', roesi_quote: 'Rösi-Quote' }
    @statistic_table = StatisticTablePerJasser.new(@date.beginning_of_year, @date.end_of_year, sortkey)
  end

  def last_12_months
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = { spiele: 'Spiele', differenz: 'Differenz', schnitt: 'Schnitt', max: 'Max', roesi: 'Rösi',
                 droesi: '2xRösi', versenkt: 'Versenkt', gematcht: 'Match', huebimatch: 'H.Match', chimiris: 'Dähler-Ris' }
    @statistic_table = StatisticTablePerJasser.new((@date - 1.year), @date, sortkey)
  end

  def last_3_months
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = { spiele: 'Spiele', differenz: 'Differenz', schnitt: 'Schnitt', max: 'Max', roesi: 'Rösi',
                 droesi: '2xRösi', versenkt: 'Versenkt', gematcht: 'Match', huebimatch: 'H.Match', chimiris: 'Dähler-Ris' }
    @statistic_table = StatisticTablePerJasser.new((@date - 3.months), @date, sortkey)
  end

  def ewig
    @date = parse_day_param(params[:date])
    sortkey = permit_sort_key(params[:order])
    @columns = { spiele: 'Spiele', differenz: 'Differenz', schnitt: 'Schnitt', max: 'Max', roesi: 'Rösi',
                 droesi: '2xRösi', versenkt: 'Versenkt', gematcht: 'Match', huebimatch: 'H.Match', chimiris: 'Dähler-Ris' }
    @statistic_table = StatisticTablePerJasser.new(Date.new(1980, 1, 1), Date.today, sortkey)
  end

  def berseker
    sortkey = permit_sort_key_berseker(params[:order])
    @date = parse_day_param(params[:date])
    @columns = { spiele: 'Spiele', eigener_schnitt: 'Eigener Schnitt', gegner_schnitt: 'Gegner Schnitt',
                 schaedling_index: 'Schaedling' }
    @statistic_table = BersekerStatisticTable.new(@date.beginning_of_year, @date.end_of_year, sortkey)
  end

  def day
    @date = parse_day_param(params[:date])
    @rounds = Round.where('day = ?', @date)
    if @rounds.empty?
      @date = Round.order(created_at: :desc).first.day
      @rounds = Round.where('day = ?', @date)
    end

    @columns = { spiele: 'Spiele', differenz: 'Differenz', schnitt: 'Schnitt', max: 'Max', roesi: 'Rösi',
                 droesi: '2xRösi', versenkt: 'Versenkt', gematcht: 'Match', huebimatch: 'H.Match', chimiris: 'Dähler-Ris' }
    @statistic_table = StatisticTablePerJasser.new(@date, @date, 'schnitt')
    @rangverschiebung = Round.calculate_rangeverschiebungs_table(@date)
  end

  def angstgegner
    sortkey = permit_sort_key_berseker(params[:order])
    @date = parse_day_param(params[:date])
    begin
      @jasser = Jasser.find(params[:id])
    rescue StandardError
      redirect_to '/ranking#year', notice: "User for id #{params[:id]} could not be found" and return
    end
    @columns = { spiele: 'Spiele', eigener_schnitt: 'Eigener Schnitt', gegner_schnitt: 'Gegner Schnitt',
                 schaedling_index: 'Schaedling' }
    @statistic_table = AngstgegnerTable.new(@jasser, @date - 1.year, @date, sortkey)
  end

  def schlimmstespiele
    @worst_average = Round.get_worst_average
    @worst_leader  = Round.get_worst_leaders
    @best_average = Round.get_best_average
  end

  private

  def permit_sort_key(suggested_key)
    if %w[spiele differenz max droesi versenkt gematcht chimiris schnitt roesi huebimatch
          versenkt_pro_spiel roesi_pro_spiel droesi_pro_spiel roesi_quote].include?(suggested_key)
      suggested_key
    else # if no permitted sortkey is provided, sort by schnitt
      'schnitt'
    end
  end

  def permit_sort_key_berseker(suggested_key)
    if %w[spiele eigener_schnitt gegner_schnitt schaedling_index].include?(suggested_key)
      suggested_key.to_sym
    else # if no permitted sortkey is provided, sort by schnitt
      :schaedling_index
    end
  end

  def parse_day_param(param)
    if param
      begin
        date = Date.parse(param)
      rescue StandardError
        # Do nothing, we will use current date a few more lines down
      end
      begin
        date ||= Date.new(param.to_i)
      rescue StandardError
        # Do nothing, we will use current date a few more lines down
      end
    end
    date ||= Date.today
    date = Date.today unless date.gregorian?
    date
  end
end
