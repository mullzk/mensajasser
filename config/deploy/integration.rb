# frozen_string_literal: true

set :application_instance, "jasserdev"
set :branch,               "main"
set :deploy_to,            "/var/www/jasserdev"

server ENV.fetch("DEPLOY_INTEGRATION_HOST"),
       user: ENV.fetch("DEPLOY_INTEGRATION_USER"),
       roles: %w[app db web]
