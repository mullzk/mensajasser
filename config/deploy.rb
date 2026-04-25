# frozen_string_literal: true

require "active_support"
require "active_support/encrypted_configuration"

DEPLOY_CREDENTIALS = ActiveSupport::EncryptedConfiguration.new(
  config_path: File.expand_path("credentials.yml.enc", __dir__),
  key_path:    File.expand_path("master.key",         __dir__),
  env_key:     "RAILS_MASTER_KEY",
  raise_if_missing_key: true
)

def deploy_server_for(stage, roles:)
  config = DEPLOY_CREDENTIALS.dig(:deploy, stage) or
    raise "Missing credentials for deploy.#{stage} in config/credentials.yml.enc"

  server config.fetch(:host), user: config.fetch(:user), roles: roles
end

set :application, "mensajasser"
set :repo_url, "git@github.com:mullzk/mensajasser.git"
set :linked_dirs, %w[log tmp/pids public/system]
set :keep_releases, 5

set :default_env, { path: "/home/deploy-app/.local/share/mise/shims:$PATH" }

before 'deploy:starting', :load_shared_env do
  on roles(:all) do
    env_content = capture("cat #{shared_path}/config/env 2>/dev/null || true")
    env_vars = {}
    env_content.each_line do |line|
      line = line.strip
      next if line.empty? || line.start_with?('#')
      key, value = line.split('=', 2)
      env_vars[key.strip] = value.to_s.strip.gsub(/\A["']|["']\z/, '') if key
    end
    SSHKit.config.default_env.merge!(env_vars)
  end
end

namespace :deploy do
  task :restart do
    on roles(:app) do
      execute :touch, "#{fetch(:current_path)}/tmp/restart.txt"
    end
  end
  after :publishing, :restart
end
