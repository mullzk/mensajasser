# frozen_string_literal: true

set :application_instance, "jasserdev"
set :branch, "main"
set :deploy_to, "/var/www/jasserdev"
server "webapps-hetzner-01.mullzk.ch", user: "deploy-app", roles: %w[app db web]
