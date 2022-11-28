# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string   'username'
      t.string   'hashed_password'
      t.string   'salt'
      t.integer  'privilege', default: 0
      t.timestamps
    end
  end
end
