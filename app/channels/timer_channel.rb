class TimerChannel < ApplicationCable::Channel
  def subscribed
    stream_for params[:user_id]
    puts "TTTTT TimerChannel subscribed to user_id(#{params[:user_id]})."
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "TTTTT TimerChannel unsubscribed."
  end
end
