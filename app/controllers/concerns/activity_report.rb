module ActivityReport
  Defaults = { days: 10 }

  Day = Struct.new(:date, :length, :tasks)
  Task = Struct.new(:id, :start, :finish, :length, :project, :name, :sessions)
  Session = Struct.new(:start, :finish, :length)
  ClientStruct = Struct.new(:id, :name)
  ProjectStruct = Struct.new(:id, :client, :name)

  def activity_report(config = {})
    @config = Defaults.deep_merge(config)
    clients = get_clients
    projects = get_projects(clients)
    raw_days = get_raw_days
    days = get_days(projects, raw_days)
    days
  end

  def get_clients
    clients = {}
    Client.where(user_id: current_user.id).pluck(:id, :name).each do |id, name|
      clients[id] = ClientStruct.new(id, name)
    end
    clients
  end

  def get_projects(clients)
    projects = {}
    Project.where(user_id: current_user.id).pluck(:id, :client_id, :name)
      .each do |id, client_id, name|
      if client = clients[client_id]
        projects[id] = ProjectStruct.new(id, client, name)
      end
    end
    projects
  end

  def get_raw_days
    first_day = Date.today.beginning_of_day.advance(days: -Defaults[:days])
    acts =
      Activity.where('user_id = ? and finish >= ?', current_user.id, first_day)
        .pluck(:id, :start, :finish, :length, :project_id, :name)
        .to_a

    # Gather the activities by date, focus.
    raw_days = {}
    acts.each do |act|
      id, start, finish, length, project_id, name = act
      date = finish.to_date
      task_key = [project_id, name]

      raw_days[date] ||= {}
      raw_day = raw_days[date]

      raw_day[task_key] ||= []
      acts = raw_day[task_key]
      acts << act
    end

    raw_days
  end

  def get_days(projects, raw_days)
    # Pack the raw days into nice structures.
    days = []

    raw_days.sort.each do |date, raw_day|
      day_length = 0
      tasks = []
      raw_day.each do |task_key, acts|
        task_project_id, task_name = task_key
        next unless project = projects[task_project_id]
        task_id = nil
        task_start = nil
        task_finish = nil
        task_length = 0

        # Gather and sort the task sessions.
        sessions = []
        acts.each do |id, start, finish, length, project_id, name|
          task_id = id
          task_start = start if !task_start || start < task_start
          task_finish = finish if !task_finish || finish > task_finish
          task_length += length
          day_length += length
          sessions << Session.new(start, finish, length)
        end
        sessions.sort! { |a, b| b.finish <=> a.finish }

        tasks <<
          Task.new(
            task_id,
            task_start,
            task_finish,
            task_length,
            project,
            task_name,
            sessions
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

      days << Day.new(date_s, day_length, tasks)
    end

    days.reverse!
  end
end
