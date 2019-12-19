import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

let sc_id = 0

class ActivityName extends Controller {
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
    this.element.addEventListener('change', this.saveName, true)
  }

  disconnect() {
    this.debug('disconnect', { this: this })
    this.element.removeEventListener('change', this.saveName)
  }

  // Save name changes.
  saveName = event => {
    const input = event.target
    const name = input.value
    const ds = input.dataset
    const scope = ds.scope
    this.debug('saveName', { ds, name, scope })
    if (!scope) return

    if (scope.includes('activity.name')) {
      const id = ds.id
      if (!id) return
      Rails.ajax({
        url: `/timer/activity/${id}`,
        type: 'PATCH',
        data: $.param({ scope, name }),
      })
    }
    else if (scope.includes('timer.name')) {
      if (!ds.timer_id) return
      Rails.ajax({
        url: '/timer/name',
        type: 'POST',
        data: $.param({ name }),
      })
    }
  }

  debug = (msg, extra = '') => {
    if (!this.debugOn) return
    this.log(msg, extra)
  }

  log = (msg, extra = '') => {
    const id = this.element.id
    const pad = msg.length < 10 ? 10 - msg.length : 0
    console.log('AN', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }
}

export default ActivityName
