# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  day        :date
#  creator    :string
#  comment    :string
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
