import consumer from "./consumer"

const user_id = $('meta[name=current-user]').attr('id')

console.log('>>>>> timer_channel.js', { user_id })

consumer.subscriptions.create(
  { channel: "TimerChannel", user_id: user_id },
  {
    received(timer) {
      console.log('##### received', { timer })
    }
  }
)
