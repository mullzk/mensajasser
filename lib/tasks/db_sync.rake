require "securerandom"

module DbSync
  module_function

  REMOTE_STAGES = %w[integration production].freeze

  def require_stage!
    stage = ENV["STAGE"] or abort "Usage: STAGE=integration rails db:pull / db:push"
    abort "Unknown stage: #{stage}. Known: #{REMOTE_STAGES.join(', ')}" unless REMOTE_STAGES.include?(stage)
    stage
  end

  def confirm_production!(stage)
    return unless stage == "production"
    print "Wirklich Production überschreiben? Tippe 'yes': "
    abort "Abgebrochen." unless $stdin.gets.to_s.strip == "yes"
  end

  def stage_credentials(stage)
    config = Rails.application.credentials.dig(:deploy, stage.to_sym) or
      abort "Missing credentials for deploy.#{stage} in config/credentials.yml.enc"
    %i[host user env_file].each do |key|
      config.fetch(key) { abort "deploy.#{stage}.#{key} fehlt in den Credentials" }
    end
    config
  end

  def ssh_target_for(stage)
    cfg = stage_credentials(stage)
    "#{cfg[:user]}@#{cfg[:host]}"
  end

  def parse_db_url(url)
    uri = URI.parse(url)
    { host: uri.host, user: uri.user, password: uri.password,
      database: uri.path.delete_prefix("/") }
  end

  def dump_filename(label)
    "jasser-#{label}-#{Time.now.strftime('%Y%m%d-%H%M%S')}-#{SecureRandom.hex(4)}.sql"
  end

  def mysqldump_cmd(db)
    "mysqldump --no-create-info --no-tablespaces --replace " \
      "--ignore-table=#{db[:database]}.schema_migrations " \
      "--ignore-table=#{db[:database]}.ar_internal_metadata " \
      "-h #{db[:host]} -u #{db[:user]} #{db[:database]}"
  end

  def mysql_import_cmd(db)
    "mysql -h #{db[:host]} -u #{db[:user]} #{db[:database]}"
  end

  def local_dump(db, path)
    system({"MYSQL_PWD" => db[:password]}, "#{mysqldump_cmd(db)} > #{path}") or
      abort "Fehler beim Dump."
  end

  def local_import(db, path)
    system({"MYSQL_PWD" => db[:password]}, "#{mysql_import_cmd(db)} < #{path}") or
      abort "Fehler beim Import."
  end

  PARSE_DB_URL_BASH = <<~'BASH'
    : "${DATABASE_URL:?DATABASE_URL not set in env_file}"
    _rest="${DATABASE_URL#*://}"
    _auth="${_rest%%@*}"
    _hostpath="${_rest#*@}"
    _user_enc="${_auth%%:*}"
    _pass_enc="${_auth#*:}"
    _hostport="${_hostpath%%/*}"
    _dbpath="${_hostpath#*/}"
    _db_enc="${_dbpath%%\?*}"
    DB_HOST="${_hostport%%:*}"
    _decode() { printf '%b' "${1//%/\x}"; }
    DB_USER=$(_decode "$_user_enc")
    DB_PASS=$(_decode "$_pass_enc")
    DB_NAME=$(_decode "$_db_enc")
  BASH

  def remote_dump(ssh, env_file, dump_path)
    run_remote ssh, <<~BASH
      set -eo pipefail
      source "#{env_file}"
      #{PARSE_DB_URL_BASH}
      MYSQL_PWD="$DB_PASS" mariadb-dump --no-create-info --no-tablespaces --replace \\
        --ignore-table="$DB_NAME.schema_migrations" \\
        --ignore-table="$DB_NAME.ar_internal_metadata" \\
        -h "$DB_HOST" -u "$DB_USER" "$DB_NAME" > "#{dump_path}"
    BASH
  end

  def remote_import(ssh, env_file, dump_path)
    run_remote ssh, <<~BASH
      set -eo pipefail
      source "#{env_file}"
      #{PARSE_DB_URL_BASH}
      MYSQL_PWD="$DB_PASS" mariadb -h "$DB_HOST" -u "$DB_USER" "$DB_NAME" < "#{dump_path}"
    BASH
  end

  def scp_from_remote(ssh, remote, local) = sh!("scp #{ssh}:#{remote} #{local}")
  def scp_to_remote(local, ssh, remote)   = sh!("scp #{local} #{ssh}:#{remote}")

  def remove_local_file(path)
    File.delete(path) if File.exist?(path)
  end

  def remove_remote_file(ssh, path)
    system(%(ssh #{ssh} "rm -f #{path}"))
  end

  def run_remote(ssh, script)
    IO.popen(["ssh", ssh, "bash", "-l", "-s"], "w") { |io| io.write(script) }
    abort "Schritt fehlgeschlagen." unless $?.success?
  end

  def step(label)
    puts "#{label}..."
    yield
  end

  def sh!(cmd)
    system(cmd) or abort "Schritt fehlgeschlagen."
  end
end

namespace :db do
  desc "Pull data from remote stage, replacing local dev DB. Usage: STAGE=integration rails db:pull. " \
       "Existing local rows are replaced; rows deleted at source remain locally."
  task :pull => :environment do
    stage      = DbSync.require_stage!
    cfg        = DbSync.stage_credentials(stage)
    ssh_target = DbSync.ssh_target_for(stage)
    local_db   = DbSync.parse_db_url(ENV.fetch("DATABASE_URL"))
    dump_path  = "/tmp/#{DbSync.dump_filename(stage)}"

    begin
      DbSync.step("1/4 Dump auf #{stage} erstellen")   { DbSync.remote_dump(ssh_target, cfg[:env_file], dump_path) }
      DbSync.step("2/4 Dump nach lokal kopieren")      { DbSync.scp_from_remote(ssh_target, dump_path, dump_path) }
      DbSync.step("3/4 Dump in lokale DB importieren") { DbSync.local_import(local_db, dump_path) }
    ensure
      DbSync.step("4/4 Dump-Dateien aufräumen") do
        DbSync.remove_remote_file(ssh_target, dump_path)
        DbSync.remove_local_file(dump_path)
      end
    end

    puts "Done. #{Result.count} Results lokal."
  end

  desc "Push local dev data to remote stage, replacing its DB. Usage: STAGE=integration rails db:push. " \
       "Existing remote rows are replaced; rows deleted locally remain at destination."
  task :push => :environment do
    stage      = DbSync.require_stage!
    DbSync.confirm_production!(stage)
    cfg        = DbSync.stage_credentials(stage)
    ssh_target = DbSync.ssh_target_for(stage)
    local_db   = DbSync.parse_db_url(ENV.fetch("DATABASE_URL"))
    dump_path  = "/tmp/#{DbSync.dump_filename('dev')}"

    begin
      DbSync.step("1/4 Dump lokal erstellen")          { DbSync.local_dump(local_db, dump_path) }
      DbSync.step("2/4 Dump nach #{stage} kopieren")   { DbSync.scp_to_remote(dump_path, ssh_target, dump_path) }
      DbSync.step("3/4 Dump auf #{stage} importieren") { DbSync.remote_import(ssh_target, cfg[:env_file], dump_path) }
    ensure
      DbSync.step("4/4 Dump-Dateien aufräumen") do
        DbSync.remove_local_file(dump_path)
        DbSync.remove_remote_file(ssh_target, dump_path)
      end
    end

    puts "Done."
  end
end
