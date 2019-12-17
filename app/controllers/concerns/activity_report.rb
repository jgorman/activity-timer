module ActivityReport
  Defaults = { days: 20 }

  # We bin activities into days by start and we show them by descending finish.

  Report = Struct.new(:days, :clients, keyword_init: true)

  Day = Struct.new(:date, :length, :tasks, keyword_init: true)

  Task =
    Struct.new(
      :id,
      :start,
      :finish,
      :length,
      :project,
      :name,
      :sessions,
      keyword_init: true
    )

  Session = Struct.new(:id, :start, :finish, :length, keyword_init: true)

  AR_Client =
    Struct.new(:id, :name, :projects, keyword_init: true) do
      def initialize(*args)
        super(*args)
        self.projects = []
      end
    end

  AR_Project = Struct.new(:id, :client, :name, :color, keyword_init: true)

  def activity_report(config = {})
    @config = Defaults.deep_merge(config)
    client_h = get_client_h
    project_h = get_project_h(client_h)
    raw_days = get_raw_days
    days = get_days(raw_days, project_h)
    clients = get_clients(client_h)
    activity_report = Report.new(days: days, clients: clients)
    activity_report
  end

  def get_clients(client_h)
    clients = client_h.values
    clients.sort! { |a, b| a.name <=> b.name }
    clients.each { |client| client.projects.sort! { |a, b| a.name <=> b.name } }
    clients
  end

  def get_client_h
    client_h = {}
    Client.where(user_id: current_user.id).pluck(:id, :name).each do |id, name|
      client_h[id] = AR_Client.new(id: id, name: name)
    end
    client_h
  end

  def get_project_h(client_h)
    project_h = {}
    Project.where(user_id: current_user.id).pluck(
      :id,
      :client_id,
      :name,
      :color
    )
      .each do |id, client_id, name, color|
      if client = client_h[client_id]
        hexcolor = sprintf('#%06x', color)
        project =
          AR_Project.new(id: id, client: client, name: name, color: hexcolor)
        project_h[id] = project
        client.projects << project
      end
    end
    project_h
  end

  def get_raw_days
    first_day = Date.today.beginning_of_day.advance(days: -Defaults[:days])
    acts =
      Activity.where('user_id = ? and start >= ?', current_user.id, first_day)
        .pluck(:id, :start, :length, :project_id, :name)
        .to_a

    # Gather the activities by date, focus.
    raw_days = {}
    acts.each do |act|
      id, start, length, project_id, name = act
      date = start.to_date
      task_key = [project_id, name]

      raw_days[date] ||= {}
      raw_day = raw_days[date]

      raw_day[task_key] ||= []
      acts = raw_day[task_key]
      acts << act
    end

    raw_days
  end

  def get_days(raw_days, project_h)
    # Pack the raw days into nice structures.
    days = []

    raw_days.sort.each do |date, raw_day|
      day_length = 0
      tasks = []
      raw_day.each do |task_key, acts|
        task_project_id, task_name = task_key
        next unless project = project_h[task_project_id]
        task_id = nil
        task_start = nil
        task_finish = nil
        task_length = 0

        # Gather and sort the task sessions.
        sessions = []
        acts.each do |id, start, length, project_id, name|
          finish = start + length
          task_id = id
          task_start = start if !task_start || start < task_start
          task_finish = finish if !task_finish || finish > task_finish
          task_length += length
          day_length += length
          sessions <<
            Session.new(id: id, start: start, finish: finish, length: length)
        end
        sessions.sort! { |a, b| b.finish <=> a.finish }

        tasks <<
          Task.new(
            id: task_id,
            start: task_start,
            finish: task_finish,
            length: task_length,
            project: project,
            name: task_name,
            sessions: sessions
          )
      end
      tasks.sort! { |a, b| b.finish <=> a.finish }

      date_s =
        if date == Date.current
          'Today'
        elsif date == Date.current - 1
          'Yesterday'
        else
          date.strftime('%a, %-d %b')
        end

      days << Day.new(date: date_s, length: day_length, tasks: tasks)
    end

    days.reverse!
  end
end
