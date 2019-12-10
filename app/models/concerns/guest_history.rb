require 'faker'

module GuestHistory
  Defaults = {
    guest: {
      email: 'guest@guest.com',
      first_name: 'Roger',
      last_name: 'Guest',
      roles: 'guest',
      password: 'guest123'
    },
    clients: 5,
    projects: 5,
    days: 90,
    sessions: 8
  }

  def guest_history(config = {})
    @config = Defaults.deep_merge(config)
    recreate_guest
    create_clients
    Time.use_zone('America/Halifax') { create_activities }
  end

  def recreate_guest
    if guest = User.find_by_email(@config[:guest][:email])
      guest.destroy!
    end
    @guest = User.new(@config[:guest])
    @guest.save!
  end

  def create_clients
    @clients = []
    @config[:clients].times do
      client = Client.new(user: @guest, name: Faker::Company.name)
      @clients << [client, create_projects(client)] if client.save
    end
  end

  def create_projects(client)
    projects = []
    @config[:projects].times do
      name = Faker::Company.catch_phrase
      project = Project.new(user: @guest, client: client, name: name)
      projects << project if project.save
    end
    projects
  end

  def create_activities
    today = Date.current
    @config[:days].downto(1) do |days_ago|
      client, projects = @clients[rand(@clients.length)]
      day = today - days_ago
      next if day.on_weekend?
      start = day.to_time.advance(hours: 9)

      8.times do
        project = projects[rand(projects.length)]
        length = (rand(23) + 1) * 5
        name = Faker::Marketing.buzzwords
        activity =
          Activity.new(
            user: @guest,
            client: client,
            project: project,
            start: start,
            length: length * 60,
            name: name
          )
            .save!
        start = start.advance(minutes: length)
      end
    end
  end
end
