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

class Jasser < ApplicationRecord
end
