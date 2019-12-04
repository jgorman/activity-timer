class TimerController < ApplicationController
  # TODO: https://api.rubyonrails.org/v6.0.1/classes/ActionView/Helpers/FormTagHelper.html#method-i-image_submit_tag

  # timer_path: GET /timer
  def index
    respond_to do |format|
      format.html do
        # Display the timer page.
        @timer = current_user.timer || Timer.new
        @activities = get_activities
        @project_options = project_options
      end

      format.json do
        # Fetch the current timer object as json.
        timer = current_user.timer
        puts "@@@@@ sending the timer..."
        TimerChannel.broadcast_to(current_user.id, timer || { name: 'No Timer' })
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
      # TODO: check that project.user == current_user
    end

    @timer = Timer.new
    @timer.user = current_user
    @timer.project = project
    @timer.start = Time.now
    @timer.name = name
    @timer.save!

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
    # TODO: check that project.user == current_user
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

    # Call replace_clock for fast feedback.
    # replace_page will get called by the js global_ticker later on.
    replace_clock
  end

  # timer_replace_page_path: GET /timer/replace_page
  def replace_page
    # Redisplay the page with the updated report.
    @timer = Timer.find_by_id(current_user.id) || Timer.new
    @activities = get_activities
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
  end

  # timer_project_path: POST /timer/project
  def project
    # TODO: check that project.user == current_user
    return unless timer = current_user.timer
    timer.project_id = params[:project_id].to_i
    timer.save!
  end

  # timer_path: DELETE /timer
  def destroy
    current_user.timer.destroy
    @timer = Timer.new
    @project_options = project_options
    respond_to { |format| format.js { render 'replace_clock' } }
  end

  private

  def get_activities
    current_user.activities.select(
      'activities.*, projects.name as project_name, clients.name as client_name'
    )
      .where('start >= ?', 10.days.ago.midnight)
      .order(start: :desc)
      .joins(:project, :client)
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
