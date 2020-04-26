# frozen_string_literal: true

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"
require "capistrano/rails"
require "capistrano/passenger"
require "capistrano/rbenv"

set :migration_role, :app

set :rbenv_type, :user
set :rbenv_ruby, "2.6.5"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

# Set deploy variables.
# https://github.com/capistrano/capistrano/issues/1884
# %i[ env bundle ruby rake ].each do |command|
#   SSHKit.config.command_map.prefix[command].push "source #{ deploy_to }/envrc &&"
# end
