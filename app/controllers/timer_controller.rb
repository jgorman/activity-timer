class TimerController < ApplicationController
  include ActivityReport

  # timer_path: GET /timer
  def index
    # session.keys.each {|key|
    #   puts sprintf('^^^^^ %-25s %s', key, session[key]) }

    respond_to do |format|
      format.html do
        # Display the timer page.
        @timer = current_user.timer || Timer.new
        @days = activity_report
        @project_options = project_options
      end

      format.json do
        # Fetch the current timer object as json.
        timer = current_user.timer
        render json: timer
      end
    end
  end

  # timer_path: POST /timer
  def create
    fields = timer_params
    project_id = fields[:project_id].to_i
    name = fields[:name]

    if project_id == 0
      project = Project.no_project(current_user)
    else
      project = Project.find(project_id)
    end

    @timer = Timer.new
    @timer.user = current_user
    @timer.project = project
    @timer.start = Time.now
    @timer.name = name
    @timer.save!
    send_timer(@timer)

    replace_clock
  end

  def replace_clock
    @timer = Timer.find_by_user_id(current_user.id) || Timer.new
    # puts "===== replace_clock #{@timer.inspect}"
    @project_options = project_options

    respond_to { |format| format.js { render 'replace_clock' } }
  end

  # timer_finish_path: POST /timer/finish
  def finish
    return unless timer = current_user.timer
    project = timer.project
    activity =
      Activity.new(
        {
          user: current_user,
          client: project.client,
          project: project,
          start: timer.start,
          length: Time.now - timer.start,
          name: timer.name
        }
      )
    activity.save!
    timer.destroy
    send_timer

    # Call replace_clock now for fast feedback.
    # timer_channel call replace_page when it gets the empty timer.
    replace_clock
  end

  # timer_replace_page_path: GET /timer/replace_page
  def replace_page
    # Redisplay the page with the updated report.
    @timer = Timer.find_by_id(current_user.id) || Timer.new
    @days = activity_report
    @project_options = project_options

    respond_to do |format|
      format.js do
        # puts "%%% replace_page.js"
        render 'replace_page'
      end
    end
  end

  # timer_name_path: POST /timer/name
  def name
    return unless timer = current_user.timer
    timer.name = params[:name] || ''
    timer.save!
    send_timer(timer)
  end

  # timer_project_path: POST /timer/project
  def project
    return unless timer = current_user.timer
    timer.project_id = params[:project_id].to_i
    timer.save!
    send_timer(timer)
  end

  # timer_activity_path: PATCH /timer/activity/:id
  def activity
    puts "##### timer_activity params(#{params.inspect})"
    id = params[:id]
    target = params[:target]
    name = params[:name]
    project_id = params[:project_id]

    if target.include?('activity.names')
      # Update all names with the same project, date and name.
      return unless activity = Activity.find_by_id(params[:id])
      return unless name
      project_id = activity.project_id
      start = activity.start
      old_name = activity.name

      Activity.where(
        'project_id = ? and ? <= start and start < ? and name = ?',
        project_id,
        start.beginning_of_day,
        start.end_of_day,
        old_name
      )
        .update_all(name: name)

      replace_page
    elsif target.include?('activity.name')
      # Update a single activity name.
      return unless activity = Activity.find_by_id(params[:id])
      return unless name
      activity.name = name
      activity.save!
      replace_page
    end
  end

  # timer_path: DELETE /timer
  def destroy
    current_user.timer.destroy
    send_timer
    @timer = Timer.new
    @project_options = project_options
    respond_to { |format| format.js { render 'replace_clock' } }
  end

  private

  def send_timer(timer = nil)
    # puts "@@@@@ sending the timer(#{timer.inspect})"
    TimerChannel.broadcast_to(current_user.id, timer)
  end

  def project_options
    opts =
      current_user.projects.select(
        'projects.id, projects.name as project_name, clients.name as client_name'
      )
        .order(updated_at: :desc)
        .joins(:client)
        .map do |project|
        pn = project.project_name
        cn = project.client_name
        pn = pn.empty? ? 'No Project' : pn
        cn = cn.empty? ? 'No Client' : cn
        ["#{cn} - #{pn}", project.id]
      end
    opts.unshift(['Select project', ''])
  end

  def timer_params
    params.require(:timer).permit(:name, :project_id)
  end
end
