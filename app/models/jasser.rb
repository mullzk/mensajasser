# == Schema Information
#
# Table name: jassers
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  disqualifiziert :boolean
#  active          :boolean          default("true")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Jasser < ApplicationRecord
  has_many :results
  has_many :rounds, through: :results

  scope :valid, -> { where('disqualifiziert=false') }

  def self.having_results_in_time_interval(from_date, to_date)
    jasser_ids = Result.joins(:round)
                       .where('rounds.day >= ? AND rounds.day<= ?', from_date, to_date)
                       .select('jasser_id')
                       .group('jasser_id')
                       .collect { |result| result[:jasser_id] }
    Jasser.where('id IN (?)', jasser_ids)
  end

  def rounds_spiele_and_differenz(from_date, to_date)
    spiele_and_differenz = {}
    results_in_time_range = Result.joins(:round)
                                  .select('rounds.day, results.spiele, results.differenz')
                                  .where('results.jasser_id=?', id)
                                  .where('rounds.day >= ? AND rounds.day<= ?', from_date, to_date)
                                  .order('rounds.day')
    results_in_time_range.each do |result|
      if spiele_and_differenz[result.day]
        spiele = result.spiele + spiele_and_differenz[result.day][:spiele]
        differenz = result.differenz + spiele_and_differenz[result.day][:differenz]
        spiele_and_differenz[result.day] =
          { day: result.day, spiele:, differenz:, schnitt: (differenz / spiele) }
      else
        spiele_and_differenz[result.day] =
          { day: result.day, spiele: result.spiele, differenz: result.differenz,
            schnitt: (result.differenz / result.spiele) }
      end
    end
    spiele_and_differenz
  end

  def first_round
    rounds.order('rounds.day').first
  end

  def timeseries_running
    timeseries_for_period(Round.day_of_first_round_in_system, Date.today, -365.days)
  end

  def timeseries_for_year(to_date)
    timeseries_for_period(to_date.beginning_of_year, to_date)
  end

  def timeseries_ewig
    timeseries_for_period(Round.day_of_first_round_in_system, Date.today)
  end

  def timeseries_for_period(from_date, to_date, clearing_period = nil)
    schnitt_for_dates = {}
    spiele_and_differenz = rounds_spiele_and_differenz(from_date, to_date)
    accumulator = { spiele: 0, differenz: 0 }

    (from_date..to_date).each do |date|
      if clearing_period && spiele_and_differenz[date + clearing_period]
        accumulator[:spiele] -= spiele_and_differenz[date + clearing_period][:spiele]
        accumulator[:differenz] -= spiele_and_differenz[date + clearing_period][:differenz]
        schnitt_for_dates[date] = accumulator[:differenz] / accumulator[:spiele].to_f if accumulator[:spiele] > 0
      end
      next unless spiele_and_differenz[date]

      accumulator[:spiele] += spiele_and_differenz[date][:spiele]
      accumulator[:differenz] += spiele_and_differenz[date][:differenz]
      schnitt_for_dates[date] = accumulator[:differenz] / accumulator[:spiele].to_f if accumulator[:spiele] > 0
    end
    schnitt_for_dates[to_date] = accumulator[:differenz] / accumulator[:spiele].to_f if accumulator[:spiele] > 0
    schnitt_for_dates
  end
end
