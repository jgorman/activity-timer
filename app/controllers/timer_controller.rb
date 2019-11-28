class TimerController < ApplicationController

  # TODO: https://api.rubyonrails.org/v6.0.1/classes/ActionView/Helpers/FormTagHelper.html#method-i-image_submit_tag

  # timer_path: GET /timer
  def index
    @timer = current_user.timer
    unless @timer
      @timer = Timer.new
      @timer.start = Time.now
      @timer.user = current_user
    end

    @activities = current_user.activities
  end

  # timer_path: POST /timer
  def create
    # TODO: check that project.user == current_user

    @timer = Timer.new(timer_params)
    @timer.user = current_user
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
    destroy
  end

  # timer_path: DELETE /timer
  def destroy
    current_user.timer.destroy!

    @timer = Timer.new
    @timer.start = Time.now
    @timer.user = current_user
    respond_to do |format|
      format.js { render 'timer_clock' }
    end
  end

  private

  def timer_params
    perms = params.require(:timer).permit(:start, :description, :project_id)
    perms
  end
end
