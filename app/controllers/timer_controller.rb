class TimerController < ApplicationController

  # TODO: https://api.rubyonrails.org/v6.0.1/classes/ActionView/Helpers/FormTagHelper.html#method-i-image_submit_tag

  # timer_path: GET /timer
  def index
    @timer = current_user.timer || Timer.new
    @activities = get_activities
  end

  # timer_path: POST /timer
  def create
    fields = timer_params
    project_id = fields[:project_id].to_i
    description = fields[:description]

    if project_id == 0
      project = Project.no_project(current_user)
    else
      project = Projects.find(project_id)
      # TODO: check that project.user == current_user
    end

    @timer = Timer.new
    @timer.user = current_user
    @timer.project = project
    @timer.start = Time.now
    @timer.description = description
    @timer.save!

    respond_to do |format|
      format.js { render 'timer_clock' }
    end
  end

  # timer_path: PATCH /timer
  def update
    # TODO: check that project.user == current_user
    @timer = current_user.timer
    @timer.update!(timer_params)

    respond_to do |format|
      format.js { render 'timer_clock' }
    end
  end

  # timer_finish_path: POST /timer/finish
  def finish
    # TODO: check that project.user == current_user
    timer = current_user.timer
    project = timer.project
    activity = Activity.new({
      user: current_user,
      client: project.client,
      project: project,
      start: timer.start,
      length: Time.now - timer.start,
      description: timer.description
    })
    activity.save!
    timer.destroy

    # Redisplay the page with the updated report.
    @timer = Timer.new
    @activities = get_activities
    render 'index'
  end

  # timer_description_path: POST /timer/description
  def description
    timer = current_user.timer
    timer.description = params[:description] || ''
    timer.save!
  end

  # timer_path: DELETE /timer
  def destroy
    current_user.timer.destroy!

    @timer = Timer.new
    respond_to do |format|
      format.js { render 'timer_clock' }
    end
  end

  private

  def get_activities
    current_user.activities
      .select('activities.*, projects.name as project_name, clients.name as client_name')
      .where('start >= ?', 10.days.ago.midnight)
      .order(start: :desc)
      .joins(:project, :client)
  end

  def timer_params
    params.require(:timer).permit(:description, :project_id)
  end
end
