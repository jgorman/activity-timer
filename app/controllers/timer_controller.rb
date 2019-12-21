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
        @activity_report = activity_report
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

  def replace_clock
    @timer = Timer.find_by_user_id(current_user.id) || Timer.new
    # puts "===== replace_clock #{@timer.inspect}"
    respond_to { |format| format.js { render 'replace_clock' } }
  end

  # timer_replace_page_path: GET /timer/replace_page
  def replace_page
    # Redisplay the page with the updated report.
    @timer = Timer.find_by_user_id(current_user.id) || Timer.new
    @activity_report = activity_report
    respond_to { |format| format.js { render 'replace_page' } }
  end

  #####
  #
  #  <%= button_to 'Load more', timer_load_more_path,
  #      params: { show_days: @activity_report.show_days + 10 },
  #      method: :post, remote: true,
  #      form_class: 'btn btn-outline-primary' %>
  #
  def load_more
    @activity_report = activity_report(show_days: params[:show_days].to_i)
    respond_to { |format| format.js { render 'replace_activity' } }
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
    return unless id = params[:id]
    new_name = params[:name]
    new_project_id = params[:project_id]
    return unless scope = params[:scope]
    return unless activity = Activity.find_by_id(id)
    redisplay = true

    if scope.include?('activity.name.task')
      # Update all activity names with the same project, date and name.
      return unless new_name
      Activity.where(
        'project_id = ? and ? <= start and start < ? and name = ?',
        activity.project_id,
        activity.start.beginning_of_day,
        activity.start.end_of_day,
        activity.name
      )
        .update_all(name: new_name)
    elsif scope.include?('activity.name.session')
      # Update a single activity name.
      return unless new_name
      activity.name = new_name
      activity.save!
    elsif scope.include?('activity.project.task')
      # Update all activity projects with the same project, date and name.
      return unless new_project_id
      return unless new_project = Project.find_by_id(new_project_id)
      start = activity.start

      Activity.where(
        'project_id = ? and ? <= start and start < ? and name = ?',
        activity.project_id,
        activity.start.beginning_of_day,
        activity.start.end_of_day,
        activity.name
      )
        .update_all(
        client_id: new_project.client_id, project_id: new_project_id
      )
    elsif scope.include?('activity.project.session')
      # Update a single activity project_id.
      return unless new_project_id
      return unless new_project = Project.find_by_id(new_project_id)
      activity.client_id = new_project.client_id
      activity.project_id = new_project_id
      activity.save!
    else
      redisplay = false
    end
    replace_page if redisplay
  end

  # timer_path: DELETE /timer
  def destroy
    current_user.timer.destroy
    send_timer
    @timer = Timer.new
    respond_to { |format| format.js { render 'replace_clock' } }
  end

  private

  def send_timer(timer = nil)
    # puts "@@@@@ sending the timer(#{timer.inspect})"
    TimerChannel.broadcast_to(current_user.id, timer)
  end

  def timer_params
    params.require(:timer).permit(:name, :project_id)
  end
end
