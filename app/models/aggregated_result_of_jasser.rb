# frozen_string_literal: true

class AggregatedResultOfJasser
  attr_reader :jasser, :spiele, :differenz, :max, :versenkt, :roesi, :droesi, :gematcht, :huebimatch, :chimiris,
              :schnitt, :versenkt_pro_spiel, :roesi_pro_spiel, :droesi_pro_spiel, :roesi_quote
  attr_accessor :rank

  def initialize(summed_up_results)
    @jasser = Jasser.find(summed_up_results.jasser_id)
    @rank = 0 # initial ranking, StatisticTablePerJasser should set rank properly

    @spiele     = summed_up_results.spiele
    @differenz  = summed_up_results.differenz
    @max        = summed_up_results.maximum
    @roesi      = summed_up_results.roesi
    @droesi     = summed_up_results.droesi
    @versenkt   = summed_up_results.versenkt

    @chimiris   = summed_up_results.chimiris
    @gematcht   = summed_up_results.gematcht
    @huebimatch = summed_up_results.huebimatch

    if @spiele&.positive?
      @schnitt              = @differenz / @spiele.to_f
      @versenkt_pro_spiel   = @versenkt / @spiele.to_f
      @roesi_pro_spiel      = @roesi / @spiele.to_f
      @droesi_pro_spiel     = @droesi / @spiele.to_f
    else
      @schnitt              = nil
      @versenkt_pro_spiel   = nil
      @roesi_pro_spiel      = nil
      @droesi_pro_spiel     = nil
    end

    @roesi_quote = (@droesi / @roesi.to_f if @roesi.positive?)
  end
end
