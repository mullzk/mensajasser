class AngstgegnerTable
  attr_reader :jasser_results

  def initialize(jasser, from_date, to_date, sortkey)
    @from_date = from_date
    @to_date = to_date
    @sortkey = sortkey

    @rounds = jasser.rounds.in_date_range(from_date, to_date)

    jasser_stats = {}

    @rounds.each do |round|
      own_result = nil
      round.results.each { |result| own_result = result if result.jasser_id == jasser.id }
      round.results.each do |result|
        next if result.jasser_id == jasser.id

        if jasser_stats[result.jasser_id].nil?
          jasser_stats[result.jasser_id] = AggregatedAngstgegnerResultsOfJasser.new
          jasser_stats[result.jasser_id].jasser = result.jasser
        end
        jasser_stats[result.jasser_id].add(spiele: result.spiele, gegner_differenz: result.differenz,
                                           own_result:)
      end
    end

    @jasser_results = jasser_stats.values

    return unless @jasser_results && @jasser_results.size > 0

    sort_and_rank_jasser_results_for_key(@sortkey)
  end

  private

  def sort_and_rank_jasser_results_for_key(sortkey)
    sortorder = sort_order_for_key(sortkey)

    unless @jasser_results && @jasser_results.size > 0 && @jasser_results[0].respond_to?(sortkey)
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

  def sort_order_for_key(sortkey)
    case sortkey
    when :spiele, :eigener_schnitt, :schaedling_index
      -1 # ascending
    when :gegner_schnitt
      1 # descending
    else
      1
    end
  end
end
