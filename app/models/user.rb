# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  hashed_password :string
#  privilege       :integer          default(0)
#  salt            :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
end
