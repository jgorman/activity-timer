class TimerController < ApplicationController

  # timer_path: GET /timer
  def show

    @timer = current_user.timer
    unless @timer
      @timer = Timer.new
      @timer.start = Time.now
      @timer.user = current_user
    end

    @projects = current_user.projects

  end

  # timer_path: POST, PATCH /timer
  def update

    # TODO: check that project.user == current_user

    @timer = current_user.timer
    if @timer

      if @timer.update(timer_params)
        puts '@@@@@ update success!'
      else
        puts '@@@@@ update failed!'
      end

    else
      @timer = Timer.new(timer_params)
      @timer.user = current_user

      if @timer.save
        puts '@@@@@ save success!'
      else
        puts '@@@@@ save failed!'
      end

    end

  end

  private

  def timer_params
    perms = params.require(:timer).permit(:start, :description, :project_id)
    perms
  end
end
