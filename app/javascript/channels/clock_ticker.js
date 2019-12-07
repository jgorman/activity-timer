import Rails from '@rails/ujs'
import { sprintf } from 'sprintf-js'

const tick_interval = 1000

class ClockTicker {
  timer = null

  constructor() {
    const now = new Date()
    this.created = sprintf('%d:%02d', now.getHours(), now.getMinutes())
    console.log(`CLOCK(${this.created}) created`)
    setInterval(this.ticker, tick_interval)
  }

  ticker = () => {
    if (this.timer) this.show_time()
  }

  new_timer = timer => {
    console.log(`CLOCK(${this.created}) new_timer()`, {
      old: this.timer,
      new: timer,
    })

    if (timer) timer.start_t = Date.parse(timer.start)
    const current_timer = this.timer
    this.timer = timer

    // Has the timer changed?
    if (current_timer && timer) {
      if (current_timer.id !== timer.id) {
        // New timer. Probably saved an activity. Replace page.
        console.log('===== id', { current_timer, timer })
        this.replace_page()
      } else if (
        current_timer.name !== timer.name ||
        current_timer.project_id !== timer.project_id
      ) {
        // The name or project changed. Replace clock.
        console.log('===== name', { current_timer, timer })
        this.replace_clock()
      } else {
        // console.log('===== unchanged', { current_timer, timer })
      }
    }

    // The timer disappeared. Probably saved an activity. Replace page.
    if (current_timer && !timer) {
      console.log('===== disappeared', { current_timer, timer })
      this.replace_page()
      this.erase_time()
    }

    // A new timer appeared. Replace clock.
    if (!current_timer && timer) {
      console.log('===== appeared', { current_timer, timer })
      this.replace_clock()
    }

    // No timer. Nothing to do.
    if (!current_timer && !timer) {
      // console.log('===== nothn', { current_timer, timer })
    }
  }

  replace_clock = () => {
    console.log('^^^^^ replace_clock')
    Rails.ajax({ type: 'GET', url: '/timer/replace_clock.js' })
  }

  replace_page = () => {
    console.log('^^^^^ replace_page')
    Rails.ajax({ type: 'GET', url: '/timer/replace_page.js' })
  }

  show_time = () => {
    // console.log('~~~~~ show_time')
    const elapsed = Date.now() - this.timer.start_t
    const elapsed_s = this.format_ms(elapsed)
    document.title = elapsed_s
    $('#nav-timer-link').html(elapsed_s)
    $('#ticker').html(elapsed_s)
  }

  erase_time = () => {
    console.log('~~~~~ erase_time')
    document.title = 'Timer'
    $('#nav-timer-link').html('Timer')
    $('#ticker').html('')
  }

  format_ms = ms => {
    const seconds = ms / 1000
    const hh = seconds / (60 * 60)
    const mm = (seconds / 60) % 60
    const ss = seconds % 60
    return sprintf('%d:%02d:%02d', hh, mm, ss)
  }
}

export default ClockTicker
