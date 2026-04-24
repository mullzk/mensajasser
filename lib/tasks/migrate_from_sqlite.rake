namespace :db do
  task migrate_from_sqlite: :environment do
    class SqliteBase < ActiveRecord::Base
      self.abstract_class = true
      establish_connection :sqlite_source
    end

    class SqliteUser   < SqliteBase; self.table_name = "users"   end
    class SqliteJasser < SqliteBase; self.table_name = "jassers" end
    class SqliteRound  < SqliteBase; self.table_name = "rounds"  end
    class SqliteResult < SqliteBase; self.table_name = "results" end

    [
      [SqliteUser,   User],
      [SqliteJasser, Jasser],
      [SqliteRound,  Round],
      [SqliteResult, Result],
    ].each do |source, target|
      puts "Migriere #{target}..."
      target.delete_all
      source.find_each do |record|
        target.insert(record.attributes)
      end
      puts "  -> #{target.count} Einträge"
    end
  end
end
