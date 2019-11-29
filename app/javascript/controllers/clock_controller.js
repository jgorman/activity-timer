import { Controller } from 'stimulus'
import { sprintf } from 'sprintf-js'
import Rails from '@rails/ujs'

var sc_id = 0

class Clock extends Controller {
  static targets = [ 'name', 'project', 'start', 'ticker' ]

  initialize() {
    this.sc_id = ++sc_id
    const debug = this.data.get('debug').toLowerCase()
    this.debugOn = debug === 'on' || debug === 'true' || debug === '1'

    this.debug('initialize', { sc: this })
  }

  connect() {
    this.debug('connect', { sc: this })

    // Start elapsed time ticking...
    this.start_time = this.get_start_time()
    if (this.start_time) {
      this.show_elapsed()
      this.ticker = setInterval(this.show_elapsed, 1000)
    }

    // Listen for field updates
    this.nameTarget.addEventListener('change', this.saveName, true)
    this.projectTarget.addEventListener('change', this.saveProject, true)
  }

  disconnect() {
    this.debug('disconnect', { sc: this })

    clearInterval(this.ticker)
    this.nameTarget.removeEventListener('change', this.saveName)
    this.projectTarget.removeEventListener('change', this.saveProject)
  }

  saveName = event => {
    // const value = event.target.value
    const name = this.nameTarget.value
    const started = this.startTarget.innerHTML.trim()
    if (started) {
      Rails.ajax({
        url: "/timer/name",
        type: "POST",
        data: `name=${name}`,
      });
    }
  }

  saveProject = event => {
    this.debug('^^^ saveProject', { field: event.target })
  }

  get_start_time = () => {
    const start = this.startTarget.innerHTML
    return start && Date.parse(start)
  }

  show_elapsed = () => {
    const elapsed = Date.now() - this.start_time
    this.tickerTarget.innerHTML = this.format_elapsed(elapsed)
  }

  format_elapsed = elapsed => {
    const seconds = elapsed / 1000
    const hh = seconds / (60 * 60)
    const mm = (seconds / 60) % 60
    const ss = seconds % 60
    return sprintf('%d:%02d:%02d', hh, mm, ss)
  }

  debug = (msg, extra = '') => {
    if (!this.debugOn) return
    this.log(msg, extra)
  }

  log = (msg, extra = '') => {
    const id = this.element.id
    const pad = msg.length < 10 ? 10 - msg.length : 0
    console.log('SC', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }

}

export default Clock
