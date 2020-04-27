# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock "~> 3.13"

# Override these as necessary in config/deploy/<stage>.rb
set :application, "activity-timer"
set :repo_url, "git@github.com:jgorman/activity-timer.git"

# Override user and deploy_to in the stage files if they differ.
set :user, "vagrant"
set :deploy_to, -> { "/home/#{fetch :user}/#{fetch :application}" }

# Set this to allow different stages to run as Rails.env = production.
set :rails_env, :production

# set :branch, :master
# set ssh_options: { :forward_agent => true }

# For multiple servers, set one server to {primary: true} for db:migrate

append :linked_dirs,
       "log",
       "tmp/pids",
       "tmp/cache",
       "tmp/sockets",
       "vendor/bundle",
       ".bundle",
       "public/system",
       "public/uploads"

# https://github.com/capistrano/rails
append :linked_files, "config/master.key"
namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! "config/master.key", "#{shared_path}/config/master.key"
        end
      end
    end
  end
end

# https://github.com/capistrano/rails
append :linked_files, "config/env.yml"
namespace :deploy do
  namespace :check do
    before :linked_files, :set_env_yml do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/env.yml ]")
          upload! "config/env.yml", "#{shared_path}/config/env.yml"
        end
      end
    end
  end
end

# Fix bug using only webpacker.
# https://makandracards.com/makandra/100898-fix-for-rails-assets-manifest-file-not-found-in-capistrano-deploy
Rake::Task["deploy:assets:backup_manifest"].clear_actions
