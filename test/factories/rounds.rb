# == Schema Information
#
# Table name: rounds
#
#  id         :bigint(8)        not null, primary key
#  comment    :string
#  creator    :string
#  day        :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#



FactoryBot.define do
  factory :round do 
  end
  
  factory :round_with_date, class: Round do 
    day {Date.today}
  end
  
end
