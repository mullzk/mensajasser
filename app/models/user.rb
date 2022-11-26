# frozen_string_literal: true

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

class User < ApplicationRecord
  #######################################
  ### START OF OLD SMELLY CODE
  #######################################

  attr_accessor :password_confirmation

  validates_confirmation_of :password
  validates_uniqueness_of :username, if: proc { |user| user.privilege.positive? }
  validates_presence_of :username, if: proc { |user| user.privilege.positive? }

  def validate
    return unless privilege.positive?

    errors.add_to_base('Für User und Admins wird ein Username benötigt') if username.blank?
    errors.add_to_base('Für User und Admins wird ein Passwort benötigt') if hashed_password.blank?
  end

  attr_reader :password

  def password=(pwd)
    @password = pwd
    return if pwd.blank?

    create_new_salt
    self.hashed_password = User.encrypted_password(password, salt)
  end

  def is_admin?
    privilege > 1
  end

  private

  def self.encrypted_password(password, salt)
    string_to_hash = "#{password}saltyBonsoir#{salt}"
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = object_id.to_s + rand.to_s
  end

  def self.authenticate(name, password)
    user = find_by_username(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      user = nil if user.hashed_password != expected_password
    end
    user
  end

  #######################################
  ### END OF OLD SMELLY CODE
  #######################################
end
