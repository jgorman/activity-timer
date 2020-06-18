import consumer from "./consumer"
import ClockTicker from "./clock_ticker"

const user_id = $("meta[name=current-user]").attr("content")
const clock = new ClockTicker()

const sub = consumer.subscriptions.create(
  { channel: "TimerChannel", user_id: user_id },
  {
    connected() {
      console.log(`TimerChannel(${user_id}) connected`, { sub })
      this.perform("get_timer")
    },

    received(timer) {
      console.log(`TimerChannel(${user_id}) received`, { timer })
      clock.new_timer(timer)
    },

    disconnected(info) {
      console.log(`TimerChannel(${user_id}) disconnected`, { info })
    },
  }
)
