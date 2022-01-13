# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  hashed_password :string
#  salt            :string
#  privilege       :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user do 
    
  end
  
end
