# frozen_string_literal: true

require "faker"

module GuestHistory
  Defaults = {
    guest: {
      email: "guest@guest.com",
      first_name: "Guest",
      last_name: "Account",
      role_s: "guest",
      password: "guest123"
    },
    clients: 5,
    projects_per_client: 5,
    project_reuse: 0.80,
    name_reuse: 0.80,
    days: 90,
    sessions: 8
  }

  def guest_history(config = {})
    @config = Defaults.deep_merge(config)
    recreate_guest
    create_clients
    Time.use_zone("America/Halifax") { create_activities }
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
    @config[:projects_per_client].times do
      name = Faker::Company.catch_phrase
      color = Project.random_color
      project =
        Project.new(user: @guest, client: client, name: name, color: color)
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

      project = nil
      name = nil
      @config[:sessions].times do
        if !project || @config[:project_reuse] < rand
          project = projects[rand(projects.length)]
          name = Faker::Marketing.buzzwords
        end
        if !name || @config[:name_reuse] < rand
          name = Faker::Marketing.buzzwords
        end
        length = (rand(23) + 1) * 5
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
