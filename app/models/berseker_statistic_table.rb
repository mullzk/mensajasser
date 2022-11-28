# frozen_string_literal: true

class BersekerStatisticTable
  attr_reader :jasser_results

  def initialize(from_date, to_date, sortkey)
    @from_date = from_date
    @to_date = to_date
    @sortkey = sortkey

    @jasser = Jasser.having_results_in_time_interval(from_date, to_date)

    @jasser_stats = {}
    @jasser.each do |jasser|
      @jasser_stats[jasser.id] = {}
      @jasser_stats[jasser.id][:jasser] = jasser
      @jasser_stats[jasser.id][:spiele] = 0
      @jasser_stats[jasser.id][:eigene_differenz] = 0
      @jasser_stats[jasser.id][:tisch_differenz] = 0
    end

    Round.in_date_range(from_date, to_date).each do |round|
      tisch_differenz = round.results.inject(0) { |acc, result| acc += result.differenz }
      round.results.each do |result|
        @jasser_stats[result.jasser_id][:spiele] += result.spiele
        @jasser_stats[result.jasser_id][:eigene_differenz] += result.differenz
        @jasser_stats[result.jasser_id][:tisch_differenz] += tisch_differenz
      end
    end

    @jasser_results = @jasser_stats.map do |_key, value|
      result = AggregatedBersekerResultsOfJasser.new
      result.jasser = value[:jasser]
      result.spiele = value[:spiele]
      result.eigene_differenz = value[:eigene_differenz]
      result.tisch_differenz  = value[:tisch_differenz]
      result
    end

    return unless @jasser_results&.size&.positive?

    sort_and_rank_jasser_results_for_key(@sortkey)
  end

  private

  def sort_and_rank_jasser_results_for_key(sortkey)
    sortorder = sort_order_for_key(sortkey)

    unless @jasser_results&.size&.positive? && @jasser_results[0].respond_to?(sortkey)
      raise "Trying to sort results with an invalid Sortkey: #{sortkey}"
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

  def sort_order_for_key(sortkey)
    case sortkey
    when :spiele, :gegner_schnitt, :schaedling_index
      -1 # ascending
    when :eigener_schnitt
      1 # descending
    else
      1
    end
  end
end
