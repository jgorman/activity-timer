import { Controller } from 'stimulus'
import { sprintf } from 'sprintf-js'

var sc_id = 0

class StimulusDebug extends Controller {
  debug = (msg, extra = '') => {
    if (!this.debugOn) return
    this.log(msg, extra)
  }

  log = (msg, extra = '') => {
    const id = this.element.id
    const pad = msg.length < 10 ? 10 - msg.length : 0
    console.log('SC', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }

  initialize() {
    this.sc_id = ++sc_id
    const debug = this.data.get('debug').toLowerCase()
    this.debugOn = debug === 'on' || debug === 'true' || debug === '1'

    this.debug('initialize', { sc: this })
  }

  connect() {
    this.debug('connect', { sc: this })

    this.start_time = this.get_start_time()
    if (this.start_time) {
      this.show_elapsed()
      this.ticker = setInterval(this.show_elapsed, 1000)
    }
  }

  get_start_time = () => {
    const timer_start = $('#timer_start')[0]
    return (
      timer_start &&
      timer_start.textContent &&
      Date.parse(timer_start.textContent)
    )
  }

  show_elapsed = () => {
    const elapsed = Date.now() - this.start_time
    $('#ticker').html(this.format_elapsed(elapsed))
  }

  format_elapsed = elapsed => {
    const seconds = elapsed / 1000
    const hh = seconds / (60 * 60)
    const mm = (seconds / 60) % 60
    const ss = seconds % 60
    return sprintf('%2d:%02d:%02d', hh, mm, ss)
  }

  disconnect() {
    this.debug('disconnect', { sc: this })
    clearInterval(this.ticker)
  }
}

export default StimulusDebug
