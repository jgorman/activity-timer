class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[edit update destroy]

  # activities_path: GET /activities
  def index
    @activities = current_user.activities
  end

  # new_project_activity_path: GET /projects/12/activities/new
  def new
    project = Project.find(params[:project_id])
    @activity = Activity.new
    @activity.start = Time.now

    # <%= form.hidden_field :project_id, value: @activity.project_id %>
    @activity.project = project
  end

  # edit_activity_path: GET /activities/9/edit
  def edit; end

  # activity_path: POST /activities
  def create
    # <%= form.hidden_field :project_id, value: @activity.project_id %>
    project = Project.find(params[:activity][:project_id])
    client = project.client

    # TODO: oops("Internal error") unless client.user.id == current_user.id

    @activity = Activity.new(activity_params)
    @activity.user = current_user
    @activity.client = project.client
    @activity.project = project

    if @activity.save
      redirect_to project
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
  end

  def activity_params
    params[:activity][:length] = hm_to_seconds(params[:activity][:length])
    perms = params.require(:activity).permit(:start, :length, :description)
    perms
  end
end
