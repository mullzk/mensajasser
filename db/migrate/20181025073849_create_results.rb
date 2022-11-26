# frozen_string_literal: true

class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.integer  'round_id',                  null: false
      t.integer  'jasser_id',                 null: false
      t.integer  'spiele',                    null: false
      t.integer  'differenz',                 null: false
      t.integer  'roesi',      default: 0, null: false
      t.integer  'droesi',     default: 0, null: false
      t.integer  'versenkt',   default: 0, null: false
      t.integer  'gematcht',   default: 0, null: false
      t.integer  'huebimatch', default: 0, null: false
      t.integer  'max',        default: 0, null: false
      t.integer  'chimiris',   default: 0, null: false
      t.timestamps
    end
  end
end
