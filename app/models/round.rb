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
    jasser_names = @results.map{|r| r.jasser.name }
    unless (jasser_names.uniq.size == jasser_names.size && jasser_names.size > 0) then errors.add_to_base("Du musst schon vier verschiedene Jasser angeben...") end
  end

  def result_attributes=(result_attributes)
    result_attributes.each do |attributes|
      results.build(attributes)
    end
  end


end
