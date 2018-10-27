# == Schema Information
#
# Table name: rounds
#
#  id         :bigint(8)        not null, primary key
#  comment    :string
#  creator    :string
#  day        :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Round < ApplicationRecord
	has_many :results, :dependent => :destroy
	has_many :jassers, :through => :results

  validate :unique_jasser
  validates_associated :results

  after_update :save_results
  
  def save_results
     results.each do |result|
       result.save(false)
     end
   end 
   
   
   def new_result_attributes=(result_attributes)
      result_attributes.each do |attributes|
        results.build(attributes)
      end
    end

    def existing_result_attributes=(result_attributes)
      results.reject(&:new_record?).each do |result|
        attributes = result_attributes[result.id.to_s]
        if attributes
          result.attributes = attributes
        else
          results.delete(result)
        end
      end
    end
  

  def unique_jasser
    ##
    ## TODO: Decide whether there may exist round without results. Here, we only check if the jassers are unique IF there are any results/jassers
    ##
    unless @results.nil? then
      jasser_names = @results.map{|r| r.jasser.name }
      unless (jasser_names.uniq.size == jasser_names.size && jasser_names.size > 0) then errors.add(:base, "Du musst schon vier verschiedene Jasser angeben...") end
    end     
  end

  def result_attributes=(result_attributes)
    result_attributes.each do |attributes|
      results.build(attributes)
    end
  end

  #######################################
  ### START OF OLD SMELLY CODE
  #######################################

	def rangverschiebungsquery_for_date(date)
	  unless date.respond_to?("strftime") then date = Date.parse(date) end
    previous_day = Round.maximum("day", :conditions => ["day < ?", date])
    beginning_of_period = previous_day.beginning_of_year
    watchdate = date.strftime("%Y-%m-%d")
    startdate = beginning_of_period.strftime("%Y-%m-%d")
		sql = <<MYEOF 
			SELECT	j.name AS name, 
							rankpr - rankpo AS rankjump,
							ELT(SIGN((gt.spieleWatchedDate IS NULL) * (rankpr - rankpo)) + 2, 'Ätsch','', 'Feigling') AS gtisch,
							rankpr,
							rankpo,
							spielepr,
						spielepo,
						diffpr, 
						diffpo,	 
						schnittpr,
						schnittpo
								FROM		(SELECT			jasser_id, 
																		(SELECT			COUNT(e2.schnitt)+1 AS rank
																		FROM				(SELECT			ROUND(SUM(e3.differenz)/SUM(e3.spiele),6) AS schnitt 
																								FROM				results	 AS e3 
																														LEFT JOIN rounds AS r ON r.id=e3.round_id 
																								WHERE				r.day >= '#{startdate}' AND r.day<='#{watchdate}' 
																								GROUP BY e3.jasser_id) 
																								AS e2
																		WHERE				(SELECT			ROUND(SUM(e4.differenz)/SUM(e4.spiele),6) 
																								FROM				results AS e4 
																														LEFT JOIN rounds AS r ON r.id=e4.round_id 
																								WHERE				e4.jasser_id=e.jasser_id 
																														AND r.day >= '#{startdate}' AND r.day<='#{watchdate}') > e2.schnitt
																		) AS rankpo,
																		SUM(spiele) AS spielepo, 
																		SUM(differenz) AS diffpo, 
																		SUM(differenz)/SUM(spiele) AS schnittpo
												FROM				results AS e
																		LEFT JOIN rounds AS r ON r.id=e.round_id
												WHERE				r.day >= '#{startdate}' AND r.day<='#{watchdate}'
												GROUP BY		jasser_id
												ORDER BY		schnittpo
												) AS po
												LEFT JOIN		(SELECT			jasser_id, 
																								(SELECT COUNT(e2.schnitt)+1 AS rank
																								FROM		(SELECT			ROUND(SUM(e3.differenz)/SUM(e3.spiele),6) AS schnitt 
																												FROM				results AS e3 
																																		LEFT JOIN rounds AS r ON r.id=e3.round_id 
																												WHERE				r.day >= '#{startdate}' AND r.day<'#{watchdate}' 
																												GROUP BY		e3.jasser_id
																												) AS e2
																								WHERE		(SELECT			ROUND(SUM(e4.differenz)/SUM(e4.spiele),6) 
																												FROM				results AS e4 
																																		LEFT JOIN rounds AS r ON r.id=e4.round_id 
																												WHERE				e4.jasser_id=e.jasser_id 
																																		AND r.day >= '#{startdate}' AND r.day<'#{watchdate}'
																												) > e2.schnitt
																								) AS rankpr,
																								SUM(spiele) AS spielepr, 
																								SUM(differenz) AS diffpr, 
																								SUM(differenz)/SUM(spiele) AS schnittpr
																		FROM				results AS e
																								LEFT JOIN rounds AS r ON r.id=e.round_id
																		WHERE				r.day >= '#{startdate}' AND r.day<'#{watchdate}'
																		GROUP BY		jasser_id
																		ORDER BY		schnittpr
												)	 AS pr ON po.jasser_id=pr.jasser_id
												LEFT JOIN jassers AS j ON po.jasser_id=j.id
												LEFT JOIN		(SELECT			jasser_id,
																								SUM(e.spiele) AS spieleWatchedDate
																		FROM				results e
																		LEFT JOIN		rounds r on r.id=e.round_id
																		WHERE				r.day >= '#{startdate}' AND r.day='#{watchdate}'
																		GROUP BY		e.jasser_id
																		) AS gt ON gt.jasser_id=j.id
								WHERE		j.disqualifiziert<>1 
								GROUP BY name 
								ORDER BY rankpo
MYEOF
	
	sql = sql.gsub(/(\t|\n)/, " ")
	
	end
	
	def calculate_rangeverschiebungs_table(date)
	  self.connection.select_all(self.rangverschiebungsquery_for_date(date))	  
  end

  #######################################
  ### END OF OLD SMELLY CODE
  #######################################  

end
