# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Running Actioncable Inside of Rails

```
vi config/cable.yml
development:
  adapter: async
# adapter: redis
# url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
# channel_prefix: activity_timer_development

vi config/environments/development.rb
  cable_in_rails = true
  if cable_in_rails
    # Mount Action Cable inside rails.
    config.action_cable.mount_path = '/cable'
  else
    # Run Action Cable outside rails.
    config.action_cable.mount_path = nil
    config.action_cable.url = 'ws://localhost:28080'
  end

bin/rails server
bin/webpack-dev-server
Visit http://localhost:3000
```


## Running Actioncable Outside of Rails

```
vi config/cable.yml
development:
# adapter: async
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: activity_timer_development

vi config/environments/development.rb
  cable_in_rails = false
  if cable_in_rails
    # Mount Action Cable inside rails.
    config.action_cable.mount_path = '/cable'
  else
    # Run Action Cable outside rails.
    config.action_cable.mount_path = nil
    config.action_cable.url = 'ws://localhost:28080'
  end

bin/rails server
bin/webpack-dev-server
redis-server
bin/cable
Visit http://localhost:3000
```
