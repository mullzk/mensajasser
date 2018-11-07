require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  setup do
    setup_jassers_rounds_and_results
  end
  
  test "Testing Test Data" do
  end
  
  test "Scopes of Rounds" do 
    t = Round.in_date_range(Date.new(2017,1,20), Date.new(2017,1,20))
    assert t.size==1, "There should be one round on 2017-01-20, but there were #{t.size}"
    assert t.first.results.size==4, "Round should have 4 results, but has #{t.first.results.size}"
    
    t = Round.in_date_range(Date.new(2018,1,1), Date.new(2018,12,31))
    assert t.size==6, "There should be 6 rounds in 2018, but there were #{t.size}"
    t = Round.with_jasser(Jasser.find_by(name:"jasser5"))
    assert t.size==3, "There should be 3 rounds with jasser5, but there were #{t.size}"
    t = Round.in_date_range(Date.new(2018,1,1), Date.new(2018,12,31)).with_jasser(@j5)
    assert t.size==2, "There should two rounds with jasser5 in 2018, but there were #{t.size}"
    
    t = Round.with_jasser(@j8)
    assert t.size==0, "There should be no rounds with jasser8, but there were #{t.size}"
    t = Round.with_jasser(@j8).in_date_range(Date.new(2018,1,1), Date.new(2018,12,31))
    assert t.size==0, "There should be no rounds with jasser8 in 2018, but there were #{t.size}"
    
  end
  
  
  private
  
  def setup_jassers_rounds_and_results
    @d2017_start = Date.new(2017,1,1)
    @d2017_end   = Date.new(2017,12,31)
    @d2018_start = Date.new(2018,1,1)
    @d2018_end   = Date.new(2018,12,31)

    @d2017_jan_start = Date.new(2017,1,1)
    @d2017_jan_end   = Date.new(2017,12,31)
    @d2018_jan_start = Date.new(2018,1,1)
    @d2018_jan_end   = Date.new(2018,1,31)
    @d2018_mar_start = Date.new(2018,3,1)
    @d2018_mar_end   = Date.new(2018,3,31)

    @d2017_jan_20   = Date.new(2017,1,20)
    @d2017_jan_21   = Date.new(2017,1,21)
    @d2017_jan_22   = Date.new(2017,1,22)

    @d2018_jan_20   = Date.new(2018,1,20)
    @d2018_jan_21   = Date.new(2018,1,21)
    @d2018_jan_22   = Date.new(2018,1,22)

    @d2018_mar_20   = Date.new(2018,3,20)
    @d2018_mar_21   = Date.new(2018,3,21)
    @d2018_mar_22   = Date.new(2018,3,22)
    
    
    @j1 = FactoryBot.create(:jasser, name:"jasser1")
    @j2 = FactoryBot.create(:jasser, name:"jasser2")
    @j3 = FactoryBot.create(:jasser, name:"jasser3")
    @j4 = FactoryBot.create(:jasser, name:"jasser4")
    @j5 = FactoryBot.create(:jasser, name:"jasser5")
    @j6 = FactoryBot.create(:jasser, name:"jasser6")
    @j7 = FactoryBot.create(:jasser, name:"jasser7")
    @j8 = FactoryBot.create(:jasser, name:"jasser8")
  
    @t1 = FactoryBot.create(:round, day:@d2017_jan_20)
    @t2 = FactoryBot.create(:round, day:@d2017_jan_21)
    @t3 = FactoryBot.create(:round, day:@d2017_jan_22)
    @t4 = FactoryBot.create(:round, day:@d2018_jan_20)
    @t5 = FactoryBot.create(:round, day:@d2018_jan_21)
    @t6 = FactoryBot.create(:round, day:@d2018_jan_22)
    @t7 = FactoryBot.create(:round, day:@d2018_mar_20)
    @t8 = FactoryBot.create(:round, day:@d2018_mar_21)
    @t9 = FactoryBot.create(:round, day:@d2018_mar_22)
    
    # 2017 January
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:4, droesi:4 , versenkt:2, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j2.id, spiele:10, differenz:110, max:30, roesi:2, droesi:3 , versenkt:1, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j3.id, spiele:10, differenz:120, max:40, roesi:3, droesi:1 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j4.id, spiele:10, differenz:130, max:50, roesi:0, droesi:0 , versenkt:0, gematcht:1, huebimatch:1, chimiris:1)

    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j2.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j4.id, spiele:10, differenz:130, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j2.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j5.id, spiele:10, differenz:130, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    # 2018 January
    FactoryBot.create(:result, round_id:@t4.id, jasser_id:@j1.id, spiele:10, differenz:100, max:25, roesi:3, droesi:4 , versenkt:2, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t4.id, jasser_id:@j2.id, spiele:10, differenz:110, max:35, roesi:0, droesi:2 , versenkt:1, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t4.id, jasser_id:@j3.id, spiele:10, differenz:120, max:40, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t4.id, jasser_id:@j4.id, spiele:10, differenz:130, max:50, roesi:2, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    FactoryBot.create(:result, round_id:@t5.id, jasser_id:@j1.id, spiele:20, differenz:300, max:40, roesi:3, droesi:4 , versenkt:2, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t5.id, jasser_id:@j2.id, spiele:20, differenz:310, max:50, roesi:0, droesi:2 , versenkt:1, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t5.id, jasser_id:@j3.id, spiele:20, differenz:320, max:60, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t5.id, jasser_id:@j5.id, spiele:20, differenz:330, max:70, roesi:2, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    FactoryBot.create(:result, round_id:@t6.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t6.id, jasser_id:@j2.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t6.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t6.id, jasser_id:@j6.id, spiele:10, differenz:130, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    # 2018 March
    FactoryBot.create(:result, round_id:@t7.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t7.id, jasser_id:@j2.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t7.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t7.id, jasser_id:@j4.id, spiele:10, differenz:130, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    FactoryBot.create(:result, round_id:@t8.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t8.id, jasser_id:@j2.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t8.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t8.id, jasser_id:@j5.id, spiele:10, differenz:130, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    FactoryBot.create(:result, round_id:@t9.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t9.id, jasser_id:@j2.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t9.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t9.id, jasser_id:@j7.id, spiele:10, differenz:130, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

  end
  
  
end
