class AggregatedAngstgegnerResultsOfJasser
  attr_accessor :jasser, :rank
  attr_reader :spiele, :eigene_differenz, :gegner_differenz, :max, :versenkt, :roesi, :droesi, :gematcht, :huebimatch,
              :chimiris

  def initialize
    @spiele = 0
    @gegner_differenz = 0
    @eigene_differenz = 0
    @roesi = 0
    @droesi = 0
    @versenkt = 0
    @gematcht = 0
    @huebimatch = 0
    @chimiris = 0
    @max = 0
    @rank = 0
  end

  def add(**named_arguments)
    @spiele += named_arguments[:spiele]
    @gegner_differenz += named_arguments[:gegner_differenz]
    @eigene_differenz += named_arguments[:own_result].differenz
    @roesi += named_arguments[:own_result].roesi
    @droesi += named_arguments[:own_result].droesi
    @versenkt  += named_arguments[:own_result].versenkt
    @gematcht  += named_arguments[:own_result].gematcht
    @huebimatch += named_arguments[:own_result].huebimatch
    @chimiris += named_arguments[:own_result].chimiris
    @max = [@max, named_arguments[:own_result].max].max
  end

  def eigener_schnitt
    @eigene_differenz / @spiele.to_f
  end

  def gegner_schnitt
    gegner_differenz / @spiele.to_f
  end

  def schaedling_index
    eigener_schnitt / gegner_schnitt
  end

  def versenkt_pro_spiel
    @versenkt / @spiele.to_f
  end

  def roesi_pro_spiel
    @roesi / @spiele.to_f
  end

  def droesi_pro_spiel
    @droesi / @spiele.to_f
  end

  def roesi_quote
    @droesi / @roesi.to_f
  end
end
