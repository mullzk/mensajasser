require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  setup do
    setup_jassers_rounds_and_results
  end
    
  test "Scopes of Rounds" do 
    t = Round.in_date_range(@d2017_jan_20, @d2017_jan_20)
    assert t.size==1, "There should be one round on 2017-01-20, but there were #{t.size}"
    assert t.first.results.size==4, "Round should have 4 results, but has #{t.first.results.size}"
    t = Round.in_date_range(@d2018_mar_21, @d2018_mar_21)
    assert t.size==2, "There should be two rounds on 2018-03-21, but there were #{t.size}"
    
    t = Round.in_date_range(@d2018_start, @d2018_end)
    assert t.size==6, "There should be 6 rounds in 2018, but there were #{t.size}"
    t = Round.with_jasser(Jasser.find_by(name:"jasser5"))
    assert t.size==3, "There should be 3 rounds with jasser5, but there were #{t.size}"
    t = Round.in_date_range(@d2018_start, @d2018_end).with_jasser(@j5)
    assert t.size==2, "There should two rounds with jasser5 in 2018, but there were #{t.size}"
    
    t = Round.with_jasser(@j8)
    assert t.size==0, "There should be no rounds with jasser8, but there were #{t.size}"
    t = Round.with_jasser(@j8).in_date_range(@d2018_start, @d2018_end)
    assert t.size==0, "There should be no rounds with jasser8 in 2018, but there were #{t.size}"
    
  end
  
  test "Scopes of Results" do
    t = Result.in_date_range(@d2017_jan_20, @d2017_jan_20)
    assert t.size==4, "There should be 4 results on 2017-01-20, but there are #{t.size}"

    t = Result.in_date_range(@d2018_mar_21, @d2018_mar_21)
    assert t.size==8, "There should be 8 results on 2018-03-21, but there are #{t.size}"    

    t = Result.with_jasser(Jasser.find_by(name:"jasser5"))
    assert t.size==3, "There should be 3 results with jasser5, but there were #{t.size}"
    t = Result.in_date_range(@d2018_start, @d2018_end).with_jasser(@j5)
    assert t.size==2, "There should two results with jasser5 in 2018, but there were #{t.size}"
  end
  
  test "Summing up Results" do
    t = Result.in_date_range(@d2017_start, @d2017_end).with_jasser(@j1).summed_up.first
    assert(t.spiele==30, "Jasser1 should have 30 Spiele in 2017, but has #{t.spiele}")
    assert(t.maximum==30, "Jasser1's maximum in 2017 should be 30, but is #{t.maximum}")
    
    
    t = Result.in_date_range(@d2017_start, @d2017_end).with_jasser(@j5).summed_up.first
    assert(t.spiele==10, "Jasser 5 should have 10 Spiele in 2017, but has #{t.spiele}")
    assert(t.maximum==20, "Jasser5's maximum in 2017 should be 20, but is #{t.maximum}")
    t = Result.in_date_range(@d2017_start, @d2017_end).with_jasser(@j6).summed_up.first
    assert_nil t, "Summed up Results for jasser6 in 2017 should return nil, but returned #{t.inspect}"
  end
    
  test "Create Statistic-Table for Year 2017" do
    statistic_table = StatisticTablePerJasser.new(@d2017_start, @d2017_end, "schnitt")
    assert(statistic_table.jasser_results && statistic_table.totals && statistic_table.averages)
    
    assert(statistic_table.jasser_results.size==5)
    result1 = statistic_table.jasser_results[0]
    assert(result1.rank==1, "Rank should be 1")
    assert(result1.jasser, "Jasser should be present")
    assert(result1.jasser.id==@j1.id)
    assert(result1.jasser.name=="jasser1")
    assert(result1.spiele==30)
    assert(result1.differenz==300)
    assert(result1.schnitt==10)
    assert(result1.max==30)
    assert(result1.roesi==4)
    assert(result1.droesi==4)
    assert(result1.versenkt==2)
    assert(result1.versenkt_pro_spiel==2/30.to_f)
    assert(result1.roesi_pro_spiel==4/30.to_f)
    assert(result1.droesi_pro_spiel==4/30.to_f)
    assert(result1.roesi_quote==1.0)
    assert(result1.chimiris==0)
    assert(result1.gematcht==0)
    assert(result1.huebimatch==0)
    

    result2 = statistic_table.jasser_results[1]
    assert(result2.rank==2)
    assert(result2.jasser)
    assert(result2.jasser.id==@j4.id)
    assert(result2.jasser.name=="jasser4")
    assert(result2.spiele==20)
    assert(result2.differenz==220)
    assert(result2.schnitt==11)
    assert(result2.max==50)
    assert(result2.roesi==0)
    assert(result2.droesi==0)
    assert(result2.versenkt==0)
    assert(result2.versenkt_pro_spiel==0.0)
    assert(result2.roesi_pro_spiel==0.0)
    assert(result2.droesi_pro_spiel==0.0)
    assert_nil(result2.roesi_quote)
    assert(result2.chimiris==1)
    assert(result2.gematcht==1)
    assert(result2.huebimatch==1)
    
    totals = statistic_table.totals
    assert(totals[:spiele]==120)
    assert(totals[:differenz]==1620)
    assert(totals[:max]==50)
    assert(totals[:versenkt]==3)
    assert_nil(totals[:schnitt])
    
    averages = statistic_table.averages
    assert(averages[:spiele]==24)
    assert(averages[:differenz]==324)
    assert(averages[:schnitt]==13.5)
    assert(averages[:versenkt]==3/5.to_f)
    assert(averages[:versenkt_pro_spiel]==3/120.to_f, "Versenkt pro Spiel should be 0.025 but was #{averages[:versenkt_pro_spiel]}")
    assert_nil(averages[:max])
    
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
    @t9 = FactoryBot.create(:round, day:@d2018_mar_21)
    
    # 2017 January
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j1.id, spiele:10, differenz:100, max:20, roesi:4, droesi:4 , versenkt:2, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j2.id, spiele:10, differenz:200, max:30, roesi:2, droesi:3 , versenkt:1, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j3.id, spiele:10, differenz:120, max:40, roesi:3, droesi:1 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t1.id, jasser_id:@j4.id, spiele:10, differenz:110, max:50, roesi:0, droesi:0 , versenkt:0, gematcht:1, huebimatch:1, chimiris:1)

    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j1.id, spiele:10, differenz:100, max:25, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j2.id, spiele:10, differenz:200, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t2.id, jasser_id:@j4.id, spiele:10, differenz:110, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j1.id, spiele:10, differenz:100, max:30, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j2.id, spiele:10, differenz:200, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j3.id, spiele:10, differenz:120, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)
    FactoryBot.create(:result, round_id:@t3.id, jasser_id:@j5.id, spiele:10, differenz:140, max:20, roesi:0, droesi:0 , versenkt:0, gematcht:0, huebimatch:0, chimiris:0)

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
