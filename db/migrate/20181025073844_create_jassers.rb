class CreateJassers < ActiveRecord::Migration[5.2]
  def change
    create_table :jassers do |t|
      t.string   'name'
      t.string   'email'
      t.boolean  'disqualifiziert'
      t.boolean  'active', default: true
      t.timestamps
    end
  end
end
