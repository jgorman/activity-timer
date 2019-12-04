import consumer from "./consumer"

console.log('>>>>> timer_channel.js')

const user_id = window.jQuery('meta[name=current-user]').attr('id')

consumer.subscriptions.create(
  { channel: "TimerChannel", user_id: user_id },
  {
    received(timer) {
      console.log('##### received', { timer })
    }
  }
)
