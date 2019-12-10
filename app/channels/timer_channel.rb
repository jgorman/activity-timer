class TimerChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:user_id].to_i
    if user_id == current_user.id
      stream_for params[:user_id]
    else
      reject
    end
  end

  def get_timer(data)
    timer = Timer.find_by(user_id: current_user.id)
    TimerChannel.broadcast_to(current_user.id, timer)
  end
end
