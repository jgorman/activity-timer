import { Controller } from 'stimulus'
import { sprintf } from 'sprintf-js'
import Rails from '@rails/ujs'

let cc_id = 0

class Clock extends Controller {
  static targets = ['name', 'project']

  initialize() {
    this.cc_id = ++cc_id
    const debug = this.data.get('debug').toLowerCase()
    this.debugOn = debug === 'on' || debug === 'true' || debug === '1'

    this.debug('initialize', { cc: this })
  }

  connect() {
    this.debug('connect', { cc: this })

    // Listen for field updates
    this.nameTarget.addEventListener('change', this.saveName, true)
    this.projectTarget.addEventListener('change', this.saveProject, true)
  }

  disconnect() {
    this.debug('disconnect', { cc: this })

    this.nameTarget.removeEventListener('change', this.saveName)
    this.projectTarget.removeEventListener('change', this.saveProject)
  }

  saveName = event => {
    const name = this.nameTarget.value
    Rails.ajax({
      url: '/timer/name',
      type: 'POST',
      data: `name=${name}`,
    })
  }

  saveProject = event => {
    const project_id = this.projectTarget.value
    Rails.ajax({
      url: '/timer/project',
      type: 'POST',
      data: `project_id=${project_id}`,
    })
  }

  debug = (msg, extra = '') => {
    if (!this.debugOn) return
    this.log(msg, extra)
  }

  log = (msg, extra = '') => {
    const id = this.element.id
    const pad = msg.length < 10 ? 10 - msg.length : 0
    console.log('CC', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }
}

export default Clock
