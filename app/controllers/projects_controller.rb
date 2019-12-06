class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # projects_path: GET /projects
  def index
    @projects = current_user.projects
  end

  def show; end

  # new_client_project_path: GET /clients/12/projects/new
  def new
    @client = Client.find(params[:client_id])
    @project = Project.new

    # <%= form.hidden_field :client_id, value: @project.client_id %>
    @project.client = @client
  end

  # edit_project_path: GET /projects/9/edit
  def edit; end

  # TODO: cleaner POST /clients/:client_id/projects
  # project_path: POST /projects
  def create
    @project = Project.new(project_params)
    @project.user = current_user

    # <%= form.hidden_field :client_id, value: @project.client_id %>
    @project.client_id = params[:project][:client_id]

    if @project.save
      redirect_to @project
    else
      render 'new'
    end
  end

  # project_path: PATCH /projects/9
  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render 'edit'
    end
  end

  # project_path: DELETE /projects/9
  def destroy
    @project.destroy
    redirect_to client_path(@project.client)
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
