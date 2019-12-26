class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: %i[new create]
  before_action :set_project, only: %i[show edit update destroy]

  # projects_path: GET /projects
  def index
    @projects = current_user.projects.order(updated_at: :desc)
  end

  def show; end

  # new_client_project_path: GET /clients/12/projects/new
  def new
    @project = Project.new
    @project.user = current_user
    @project.client = @client
    @project.color = Project.random_color
  end

  # edit_project_path: GET /projects/9/edit
  def edit; end

  # client_projects_path POST /clients/:client_id/projects
  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project.client = @client

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

  def set_client
    @client = Client.find(params[:client_id])
    unless @client.user_id == current_user.id
      return oops_page('Unauthorized access')
    end
  end

  def set_project
    @project = Project.find(params[:id])
    unless @project.user_id == current_user.id
      return oops_page('Unauthorized access')
    end
  end

  def project_params
    params.require(:project).permit(:name)

    perms = params.require(:project).permit(:name, :color)
    if color_s = perms[:color]
      perms[:color] = color_s.gsub(/\H/, '').to_i(16)
    end
    perms
  end
end
