# frozen_string_literal: true

# == Schema Information
#
# Table name: jassers
#
#  id              :bigint           not null, primary key
#  active          :boolean          default(TRUE)
#  disqualifiziert :boolean
#  email           :string(255)
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "test_helper"
require "factory_bot"

class JasserTest < ActiveSupport::TestCase
  test "Basic working of Jasser-Factory" do
    jasser = FactoryBot.create(:jasser)
    assert_not(jasser.disqualifiziert, "Default Jasser is disqualifiziert")
    assert(jasser.active, "Default Jasser is not active")
  end
end
