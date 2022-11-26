# frozen_string_literal: true

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  day        :date
#  creator    :string
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Round < ApplicationRecord
  has_many :results, dependent: :destroy, inverse_of: :round
  has_many :jassers, through: :results

  validates_presence_of :day

  validate :all_jassers_unique?
  validates_associated :results
  accepts_nested_attributes_for :results

  scope :in_date_range, ->(from_date, to_date) { where('rounds.day >= ? AND rounds.day<= ?', from_date, to_date) }
  scope :with_jasser, ->(jasser) { joins(:results).where('results.jasser_id=?', jasser.id) }

  scope :summed_on_ris, lambda {
                          joins(:results).select('rounds.id, sum(results.spiele) spiele, sum(results.differenz) differenz, (sum(differenz)/sum(CAST(spiele as decimal))) schnitt').group('rounds.id')
                        }
  scope :best_player_on_ris, lambda {
                               joins(:results).select('rounds.id, max(results.spiele) spiele, min(results.differenz) differenz, (min(differenz/CAST(spiele as decimal))) schnitt').group('rounds.id')
                             }

  after_initialize do |_round|
    @results = []
  end

  def all_jassers_unique?
    jasser_names = results.map { |r| r.jasser.name }
    unless jasser_names.uniq.size == jasser_names.size then errors.add(:base,
                                                                       'Ein Jasser darf nur einmal im Tableau vertreten sein...') end
  end

  def self.day_of_first_round_in_system
    Round.order(:day).first.day
  end

  def self.calculate_rangeverschiebungs_table(date)
    ## Set Up the Dates of the new round, the day before and the first day of the year (where the main statistik begins)
    date = Date.parse(date) unless date.respond_to?('strftime')
    previous_day = Round.where('day < ?', date).maximum('day')
    if previous_day.nil? then return {} end # If there are no rounds older than the Date, a rangverschiebungstable doesn't make any sense

    beginning_of_period = previous_day.beginning_of_year

    new_ranking_table = StatisticTablePerJasser.new(beginning_of_period, date, 'schnitt').jasser_results
    old_ranking_table = StatisticTablePerJasser.new(beginning_of_period, previous_day, 'schnitt').jasser_results
    ## Consolidate both Ranking-Hashes into the Rangverschiebungs-Tabelle
    rangverschiebungs_tabelle = new_ranking_table.map do |new_jasser_result|
      jasser_verschiebung = {}
      jasser_verschiebung[:jasser_name] = new_jasser_result.jasser.name
      jasser_verschiebung[:rang_nachher] = new_jasser_result.rank
      jasser_verschiebung[:spiele_nachher] = new_jasser_result.spiele
      jasser_verschiebung[:differenz_nachher] = new_jasser_result.differenz
      jasser_verschiebung[:schnitt_nachher] = new_jasser_result.schnitt

      old_ranking_table.each do |old_jasser_result|
        next unless old_jasser_result.jasser == new_jasser_result.jasser

        jasser_verschiebung[:rang_vorher] = old_jasser_result.rank
        jasser_verschiebung[:spiele_vorher] = old_jasser_result.spiele
        jasser_verschiebung[:differenz_vorher] = old_jasser_result.differenz
        jasser_verschiebung[:schnitt_vorher] = old_jasser_result.schnitt
        jasser_verschiebung[:rang_sprung] = jasser_verschiebung[:rang_vorher] - jasser_verschiebung[:rang_nachher]
        if jasser_verschiebung[:spiele_vorher] != jasser_verschiebung[:spiele_nachher]
          jasser_verschiebung[:sprung_am_gruenen_tisch] = ''
        else
          # Jasser did not play on last day, so he potentially changed his rank on the grünen Tisch
          jasser_verschiebung[:sprung_am_gruenen_tisch] = if (jasser_verschiebung[:rang_sprung]).positive?
                                                            '(Feigling)'
                                                          elsif (jasser_verschiebung[:rang_sprung]).negative?
                                                            '(Ätsch)'
                                                          else
                                                            ''
                                                          end
        end
      end
      jasser_verschiebung
    end

    rangverschiebungs_tabelle.sort { |a, b| a[:rang_nachher] <=> b[:rang_nachher] }
  end

  def self.get_worst_average
    Round.summed_on_ris.where('spiele > 15').order('schnitt desc').limit(20).map do |result|
      Round.find(result.id)
    end
  end

  def self.get_worst_leaders
    Round.best_player_on_ris.order('schnitt desc').limit(20).map do |result|
      Round.find(result.id)
    end
  end

  def self.get_best_average
    Round.summed_on_ris.where('spiele > 15').order('schnitt asc').limit(20).map do |result|
      Round.find(result.id)
    end
  end
end
