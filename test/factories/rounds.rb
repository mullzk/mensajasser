# frozen_string_literal: true

# == Schema Information
#
# Table name: rounds
#
#  id         :bigint           not null, primary key
#  comment    :string(255)
#  creator    :string(255)
#  day        :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :round do
  end

  factory :round_with_date, class: Round do
    day { Date.today }
  end
end
