# frozen_string_literal: true

set :application, "mensajasser"
set :repo_url, "git@github.com:mullzk/mensajasser.git"
set :linked_dirs, %w[log tmp/pids public/system]
set :keep_releases, 5

# mise instead of rbenv/rvm — ensures correct Ruby on remote server
SSHKit.config.command_map[:bundle] = "/usr/local/bin/mise exec -- bundle"
SSHKit.config.command_map[:rake]   = "/usr/local/bin/mise exec -- rake"
SSHKit.config.command_map[:rails]  = "/usr/local/bin/mise exec -- rails"

namespace :deploy do
  task :restart do
    on roles(:app) do
      execute :touch, "#{fetch(:current_path)}/tmp/restart.txt"
    end
  end
  after :publishing, :restart
end
