# frozen_string_literal: true

# == Schema Information
#
# Table name: results
#
#  id         :integer          not null, primary key
#  round_id   :integer          not null
#  jasser_id  :integer          not null
#  spiele     :integer          not null
#  differenz  :integer          not null
#  roesi      :integer          default("0"), not null
#  droesi     :integer          default("0"), not null
#  versenkt   :integer          default("0"), not null
#  gematcht   :integer          default("0"), not null
#  huebimatch :integer          default("0"), not null
#  max        :integer          default("0"), not null
#  chimiris   :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Result < ApplicationRecord
  belongs_to :jasser
  belongs_to :round, inverse_of: :results

  validates_numericality_of :spiele, :differenz, :roesi, :droesi, :versenkt, :gematcht, :huebimatch, :max, :chimiris
  validates_presence_of :spiele, :differenz, :jasser_id

  scope :in_date_range, lambda { |from_date, to_date|
                          joins(:round).where('rounds.day >= ? AND rounds.day<= ?', from_date, to_date)
                        }
  scope :with_jasser, ->(jasser) { where('jasser_id=?', jasser.id) }
  scope :summed_up, lambda {
                      select("jasser_id, sum(spiele) spiele,
                                    sum(differenz) differenz,
                                    max(max) maximum,
                                    sum(roesi) roesi,
                                    sum(droesi) droesi,
                                    sum(versenkt) versenkt,
                                    sum(gematcht) gematcht,
                                    sum(huebimatch) huebimatch,
                                    sum(chimiris) chimiris").group('jasser_id').order('jasser_id')
                    }
  scope :daily_sum_for_all_users, lambda {
                                    select('sum(spiele) spiele, sum(differenz) differenz, rounds.day as day').group('day').order('day')
                                  }

  def schnitt
    @spiele ? @differenz / @spiele : 0
  end

  def schnitt=(schnitt)
    # noop
  end

  def self.timeseries_running_ewig(from_date = Round.day_of_first_round_in_system, to_date = Date.today, clearing_period = -365.days)
    # Return-Value: 2D-Hash: Dates=>Averages
    schnitt_for_dates = {}

    # Data-Hash: Sums of Spiele and Differenz on every Day
    spiele_and_differenz = Result.in_date_range(from_date,
                                                to_date).daily_sum_for_all_users.each_with_object({}) do |result, hash|
      hash[Date.parse(result.day)] = result
    end

    accumulator = { spiele: 0, differenz: 0 }

    (from_date..to_date).each do |date|
      if clearing_period && spiele_and_differenz[date + clearing_period]
        accumulator[:spiele] -= spiele_and_differenz[date + clearing_period][:spiele]
        accumulator[:differenz] -= spiele_and_differenz[date + clearing_period][:differenz]
        if (accumulator[:spiele]).positive?
          schnitt_for_dates[date] =
            accumulator[:differenz] / accumulator[:spiele].to_f
        end
      end
      next unless spiele_and_differenz[date]

      accumulator[:spiele] += spiele_and_differenz[date][:spiele]
      accumulator[:differenz] += spiele_and_differenz[date][:differenz]
      schnitt_for_dates[date] = accumulator[:differenz] / accumulator[:spiele].to_f if (accumulator[:spiele]).positive?
    end
    schnitt_for_dates[to_date] = accumulator[:differenz] / accumulator[:spiele].to_f if (accumulator[:spiele]).positive?
    schnitt_for_dates
  end
end
