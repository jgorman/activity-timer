set :branch, :m2
set :rails_env, :production
server "uhe", user: 'uheadmin', roles: %w{app web}
