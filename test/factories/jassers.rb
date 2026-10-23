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
