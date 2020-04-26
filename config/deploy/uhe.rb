# frozen_string_literal: true

set :deploy_to, "/home/uheadmin/activity-timer"
server "uhe", user: "uheadmin", roles: %w{app web}
