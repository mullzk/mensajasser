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

require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  setup do
  end
  
  test "Tableau with multiple instances of the same jasser should throw an error" do
    round = Round.new
    round.day = Date.today
    jasser1 = FactoryBot.create(:uniquely_named_jasser)
    jasser2 = FactoryBot.create(:uniquely_named_jasser)
    round.results.build(jasser:jasser1, spiele:20, differenz:200)
    round.results.build(jasser:jasser1, spiele:20, differenz:200)
    round.results.build(jasser:jasser2, spiele:20, differenz:200)
    round.results.build(jasser:jasser2, spiele:20, differenz:200)
    assert_not(round.save)
  end
  
  test "Tableau with 4 different jassers should not throw an error" do
    round = Round.new
    round.day = Date.today
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    assert(round.save)
  end
  
  
  test "Tableau without differences should throw an error" do
    ## Rethink: Should result.spiele and result.differenz really be NOT NULL but not default to 0? 
    round = Round.new
    round.day = Date.today
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser))
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    round.results.build(jasser:FactoryBot.create(:uniquely_named_jasser), spiele:20, differenz:200)
    assert_not(round.save)
  end
  

end
