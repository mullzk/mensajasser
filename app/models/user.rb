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




  #######################################
  ### START OF OLD SMELLY CODE
  #######################################

  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validates_uniqueness_of :username, if: Proc.new { |user| user.privilege > 0 }
  validates_presence_of :username, if: Proc.new { |user| user.privilege > 0 }

  def validate
    if privilege > 0
      errors.add_to_base("Für User und Admins wird ein Username benötigt") if username.blank?
      errors.add_to_base("Für User und Admins wird ein Passwort benötigt") if hashed_password.blank?
    end
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def is_admin?
    self.privilege > 1
  end

  private



    def self.encrypted_password(password, salt)
      string_to_hash = password + "saltyBonsoir" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end

    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s    
    end


    def self.authenticate(name, password)
      user = self.find_by_username(name)
      if user
        expected_password = encrypted_password(password, user.salt)
        if user.hashed_password != expected_password
          user = nil
        end
      end
      user
    end

  #######################################
  ### END OF OLD SMELLY CODE
  #######################################  
end
