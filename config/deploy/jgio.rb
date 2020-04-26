# frozen_string_literal: true

set :deploy_to, "/u/jgio/activity-timer"
server "johngorman.io", user: "jg", roles: %w{app web}
