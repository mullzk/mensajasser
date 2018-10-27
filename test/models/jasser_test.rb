# == Schema Information
#
# Table name: jassers
#
#  id              :bigint(8)        not null, primary key
#  active          :boolean          default(TRUE)
#  disqualifiziert :boolean
#  email           :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'
require 'factory_bot'

class JasserTest < ActiveSupport::TestCase   
   test "Basic working of Jasser-Factory" do 
     jasser = FactoryBot.create(:jasser)
     assert_not(jasser.disqualifiziert, "Default Jasser is disqualifiziert")
     assert(jasser.active, "Default Jasser is not active")     
   end   
end
