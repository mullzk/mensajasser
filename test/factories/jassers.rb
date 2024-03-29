# frozen_string_literal: true

# == Schema Information
#
# Table name: jassers
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  disqualifiziert :boolean
#  active          :boolean          default("true")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :jasser do
  end

  # This will use the User class (Admin would have been guessed)
  factory :disqualifizierter_jasser, class: Jasser do
    disqualifiziert { false }
  end

  factory :inaktiver_jasser, class: Jasser do
    active { false }
  end

  factory :uniquely_named_jasser, class: Jasser do
    sequence(:name) { |n| "jasser#{n}" }
  end
end
