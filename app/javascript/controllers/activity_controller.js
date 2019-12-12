import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

let sc_id = 0

class Activity extends Controller {

  initialize() {
    this.sc_id = ++sc_id
    if (this.data.has('debug')) {
      const debug = this.data.get('debug').toLowerCase()
      this.debugOn = debug === 'on' || debug === 'true' || debug === '1'
    }
    this.debug('initialize', { this: this })
  }

  connect() {
    this.debug('connect', { this: this })
    this.element.addEventListener('change', this.saveChange, true)
  }

  disconnect() {
    this.debug('disconnect', { this: this })
    this.element.removeEventListener('change', this.saveChange)
  }

  saveChange = event => {
    const input = event.target
    const value = input.value
    const target = input.dataset.target
    const id = input.dataset.id
    this.debug('saveChange', { input, value, target, id })
    if (target !== 'activity.name') return

    Rails.ajax({
      url: `/activities/${id}`,
      type: 'PATCH',
      data: `activity[name]=${value}`,
    })
  }

  debug = (msg, extra = '') => {
    if (!this.debugOn) return
    this.log(msg, extra)
  }

  log = (msg, extra = '') => {
    const id = this.element.id
    const pad = msg.length < 10 ? 10 - msg.length : 0
    console.log('AC', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }
}

export default Activity
