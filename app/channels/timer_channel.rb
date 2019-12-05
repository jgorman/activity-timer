class TimerChannel < ApplicationCable::Channel
  def initialize(*args)
    super(*args)
    puts "TTTTT TimerChannel init"
  end

  def subscribed
    user_id = params[:user_id].to_i
    if user_id == current_user.id
      puts "TTTTT TimerChannel subscribed to user_id(#{user_id})."
      stream_for params[:user_id]
    else
      puts "TTTTT TimerChannel rejected params(#{user_id}) != user(#{current_user.id})."
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "TTTTT TimerChannel unsubscribed."
  end
end
