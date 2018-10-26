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

FactoryBot.define do
  factory :jasser do
    name { "Mullzk" }
  end

  # This will use the User class (Admin would have been guessed)
  factory :disqualifizierter_jasser, class: Jasser do
    name { "Hannes" }
    disqualifiziert { false }
  end

  factory :inaktiver_jasser, class: Jasser do
    name { "Knudi" }
    active { false }
  end

end
