class AggregatedBersekerResultsOfJasser
  attr_accessor :jasser, :spiele, :eigene_differenz, :tisch_differenz, :rank

  def gegner_differenz
    @tisch_differenz - @eigene_differenz
  end

  def eigener_schnitt
    @eigene_differenz / @spiele.to_f
  end

  def tisch_schnitt
    @tisch_differenz / 4.0 / @spiele.to_f
  end

  def gegner_schnitt
    gegner_differenz / 3.0 / spiele.to_f
  end

  def schaedling_index
    gegner_schnitt / eigener_schnitt
  end
end
