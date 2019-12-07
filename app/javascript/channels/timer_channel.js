import consumer from './consumer'
import ClockTicker from './clock_ticker'

const user_id = $('meta[name=current-user]').attr('id')
console.log('>>>>> timer_channel.js', { user_id })

const clock = new ClockTicker()

const sub = consumer.subscriptions.create(
  { channel: 'TimerChannel', user_id: user_id },
  {
    initialized() {
      console.log(`##### initialized ${user_id}`)
    },

    connected() {
      console.log(`##### connected ${user_id}`, { this: this, sub })
      this.perform('get_timer')
    },

    received(timer) {
      console.log(`##### received ${user_id}`, { timer })
      clock.new_timer(timer)
    },

    disconnected() {
      console.log(`##### disconnected ${user_id}`)
    },
  }
)
