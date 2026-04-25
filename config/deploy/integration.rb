# frozen_string_literal: true

set :application_instance, "jasserdev"
set :branch,               "main"
set :deploy_to,            "/var/www/jasserdev"

deploy_server_for :integration, roles: %w[app db web]
