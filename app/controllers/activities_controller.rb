class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[new create]
  before_action :set_activity, only: %i[edit update destroy]

  # new_project_activity_path: GET /projects/12/activities/new
  def new
    @activity = Activity.new
    @activity.start = Time.now
    @activity.project = @project
    @activity.client = @project.client
  end

  # edit_activity_path: GET /activities/9/edit
  def edit; end

  # project_activities_path: POST /projects/12/activities
  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user
    @activity.project = @project
    @activity.client = @project.client

    if @activity.save
      redirect_to @activity.project
    else
      render 'new'
    end
  end

  # activity_path: PATCH /activities/9
  def update
    if @activity.update(activity_params)
      redirect_to @activity.project
    else
      render 'edit'
    end
  end

  # activity_path: DELETE /activities/9
  def destroy
    @activity.destroy
    redirect_to project_path(@activity.project)
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
    unless @activity.user_id == current_user.id
      return alert_page('Unauthorized access.')
    end
  end

  def set_project
    @project = Project.find(params[:project_id])
    unless @project.user_id == current_user.id
      return alert_page('Unauthorized access.')
    end
  end

  def activity_params
    perms = params.require(:activity).permit(:start, :length, :name)
    if length_s = perms[:length]
      perms[:length] = hm_to_seconds(length_s)
    end
    perms
  end
end
