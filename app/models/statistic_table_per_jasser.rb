# frozen_string_literal: true

class StatisticTablePerJasser
  attr_reader :jasser_results, :totals, :averages

  def initialize(from_date, to_date, sortkey)
    @from_date = from_date
    @to_date = to_date
    @sortkey = sortkey

    summed_up_results = Result.in_date_range(from_date, to_date).summed_up

    @jasser_results = []
    summed_up_results.each do |summed_up_result|
      statistic_for_jasser = AggregatedResultOfJasser.new(summed_up_result)
      @jasser_results << statistic_for_jasser unless statistic_for_jasser.jasser.disqualifiziert
    end

    return unless @jasser_results&.size&.positive?

    sort_and_rank_jasser_results_for_key(@sortkey)
    @totals = calculate_totals(@jasser_results)
    @averages = calculate_averages(@jasser_results, @totals)
  end

  private

  def sort_and_rank_jasser_results_for_key(sortkey)
    sortorder = sort_order_for_key(sortkey)

    unless @jasser_results&.size&.positive? && @jasser_results[0].respond_to?(sortkey)
      raise 'Trying to sort results with an invalid Sortkey'
    end

    results_with_sortkey = @jasser_results.select { |stat| stat.send(sortkey) }
    results_without_sortkey = @jasser_results.reject { |stat| stat.send(sortkey) }

    results_with_sortkey.sort! { |a, b| sortorder * (a.send(sortkey) <=> b.send(sortkey)) }

    @jasser_results = results_with_sortkey.concat results_without_sortkey
    rank = 1
    @jasser_results.each do |result|
      result.rank = rank
      rank += 1
    end
    @jasser_results
  end

  def calculate_totals(jasser_results)
    totals = OpenStruct.new
    %i[spiele differenz roesi droesi versenkt gematcht huebimatch chimiris].each do |col|
      totals[col] = jasser_results.inject(0) { |acc, single_result| acc += single_result.send(col) }
    end
    totals[:max] = jasser_results.inject(0) { |acc, single_result| acc = [acc, single_result.max].max }
    totals[:schnitt] = nil
    %i[versenkt_pro_spiel roesi_pro_spiel droesi_pro_spiel roesi_quote].each do |col|
      totals[col] = nil
    end
    totals
  end

  def calculate_averages(jasser_results, totals)
    jassers = jasser_results.size.to_f
    if jassers.positive? && totals[:spiele] && (totals[:spiele]).positive?
      averages = OpenStruct.new
      %i[spiele differenz roesi droesi versenkt gematcht huebimatch chimiris].each do |col|
        averages[col] = totals[col] / jassers
      end
      averages[:max] = nil
      spiele = totals[:spiele].to_f
      averages[:schnitt] = totals[:differenz] / spiele
      averages[:versenkt_pro_spiel]   = totals[:versenkt] / spiele
      averages[:roesi_pro_spiel]      = totals[:roesi]    / spiele
      averages[:droesi_pro_spiel]     = totals[:droesi]   / spiele
      averages[:roesi_quote] = totals[:droesi] / totals[:roesi].to_f if (totals[:roesi]).positive?
    end
    averages
  end

  def sort_order_for_key(sortkey)
    case sortkey
    when 'spiele', 'differenz', 'maximum', 'droesi', 'versenkt', 'gematcht', 'chimiris', 'versenkt_pro_spiel', 'droesi_pro_spiel', 'roesi_quote'
      -1 # ascending
    when 'schnitt', 'roesi', 'roesi_ps', 'huebimatch'
      1 # descending
    else
      1
    end
  end
end
