require "securerandom"
require "shellwords"

namespace :db do
  REMOTE_STAGES = %w[integration production].freeze

  desc "Pull data from remote stage into local dev (e.g. rails db:pull[integration])"
  task :pull, [:stage] => :environment do |_, args|
    stage      = require_stage!(args)
    ssh_target = ssh_target_for(stage)
    local_db   = parse_db_url(ENV.fetch("DATABASE_URL"))
    remote_db  = parse_db_url(fetch_remote_database_url(stage))
    dump_path  = "/tmp/#{dump_filename(stage)}"

    begin
      step "1/4 Dump auf #{stage} erstellen"   do remote_dump(ssh_target, remote_db, dump_path) end
      step "2/4 Dump nach lokal kopieren"      do scp_from_remote(ssh_target, dump_path, dump_path) end
      step "3/4 Dump in lokale DB importieren" do local_import(local_db, dump_path) end
    ensure
      step "4/4 Dump-Dateien aufräumen" do
        remove_remote_file(ssh_target, dump_path)
        remove_local_file(dump_path)
      end
    end

    puts "Done. #{Result.count} Results lokal."
  end

  desc "Push local dev data to remote stage (e.g. rails db:push[integration])"
  task :push, [:stage] => :environment do |_, args|
    stage = require_stage!(args)
    confirm_production!(stage)
    ssh_target = ssh_target_for(stage)
    local_db   = parse_db_url(ENV.fetch("DATABASE_URL"))
    remote_db  = parse_db_url(fetch_remote_database_url(stage))
    dump_path  = "/tmp/#{dump_filename('dev')}"

    begin
      step "1/4 Dump lokal erstellen"          do local_dump(local_db, dump_path) end
      step "2/4 Dump nach #{stage} kopieren"   do scp_to_remote(dump_path, ssh_target, dump_path) end
      step "3/4 Dump auf #{stage} importieren" do remote_import(ssh_target, remote_db, dump_path) end
    ensure
      step "4/4 Dump-Dateien aufräumen" do
        remove_local_file(dump_path)
        remove_remote_file(ssh_target, dump_path)
      end
    end

    puts "Done."
  end

  # --- argument & credentials handling --------------------------------------

  def require_stage!(args)
    stage = args[:stage] or abort "Usage: rails db:pull[integration] / db:push[integration]"
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

  def fetch_remote_database_url(stage)
    cfg = stage_credentials(stage)
    ssh = "#{cfg[:user]}@#{cfg[:host]}"
    url = `ssh #{ssh} "grep '^DATABASE_URL=' #{cfg[:env_file]} | cut -d= -f2-"`.strip
    abort "Konnte DATABASE_URL nicht aus #{cfg[:env_file]} lesen" if url.empty?
    url
  end

  def parse_db_url(url)
    uri = URI.parse(url)
    { host: uri.host, user: uri.user, password: uri.password,
      database: uri.path.delete_prefix("/") }
  end

  # --- step primitives ------------------------------------------------------

  def dump_filename(label)
    "jasser-#{label}-#{Time.now.strftime('%Y%m%d-%H%M%S')}-#{SecureRandom.hex(4)}.sql"
  end

  def mysqldump_cmd(db)
    "mysqldump --no-create-info --no-tablespaces " \
      "--ignore-table=#{db[:database]}.schema_migrations " \
      "-h #{db[:host]} -u #{db[:user]} -p#{db[:password].shellescape} #{db[:database]}"
  end

  def mysql_import_cmd(db)
    "mysql -h #{db[:host]} -u #{db[:user]} -p#{db[:password].shellescape} #{db[:database]}"
  end

  def local_dump(db, path)         = sh!("#{mysqldump_cmd(db)} > #{path}")
  def remote_dump(ssh, db, path)   = sh!(%(ssh #{ssh} "#{mysqldump_cmd(db)} > #{path}"))
  def local_import(db, path)       = sh!("#{mysql_import_cmd(db)} < #{path}")
  def remote_import(ssh, db, path) = sh!(%(ssh #{ssh} "#{mysql_import_cmd(db)} < #{path}"))
  def scp_from_remote(ssh, remote, local) = sh!("scp #{ssh}:#{remote} #{local}")
  def scp_to_remote(local, ssh, remote)   = sh!("scp #{local} #{ssh}:#{remote}")
  def remove_local_file(path)             = File.delete(path) if File.exist?(path)
  def remove_remote_file(ssh, path)       = system(%(ssh #{ssh} "rm -f #{path}"))

  def step(label)
    puts "#{label}..."
    yield
  end

  def sh!(cmd)
    abort "Fehler bei: #{cmd}" unless system(cmd)
  end
end
