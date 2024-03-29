# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.date     'day'
      t.string   'creator'
      t.string   'comment'
      t.timestamps
    end
  end
end
