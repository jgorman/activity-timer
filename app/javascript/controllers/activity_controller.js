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
    this.element.addEventListener('change', this.saveName, true)

    const flash = {}
    const $project_select = $('#project-select')
    $project_select.on('show.bs.modal', event => this.captureIds(event, flash))
    $project_select.on('click', event => this.saveProject(event, flash))
  }

  disconnect() {
    this.debug('disconnect', { this: this })
    this.element.removeEventListener('change', this.saveName)
    const $project_select = $('#project-select')
    $project_select.off('show.bs.modal')
    $project_select.off('click')
  }

  // Capture the session's activity_id and scope.
  captureIds = (event, flash) => {
    const ds = event.relatedTarget.dataset
    if (!ds.scope || !ds.activity_id || !ds.project_id) return
    flash.scope = ds.scope
    flash.activity_id = ds.activity_id
    flash.project_id = ds.project_id
    //this.debug('captureIds', { flash })
  }

  // Save selected project.
  saveProject = (event, flash) => {
    const clicked = event.target
    const project_id = clicked.dataset.project_id
    if (!project_id) return
    if (!flash.activity_id || !flash.scope) return
    $('#project-select').modal('hide')
    //this.debug('saveProject', { project_id, flash, })

    if (flash.scope.includes('activity.project')) {
      Rails.ajax({
        url: `/timer/activity/${flash.activity_id}`,
        type: 'PATCH',
        data: $.param({ scope: flash.scope, project_id }),
      })
    }
  }

  // Save name changes.
  saveName = event => {
    const input = event.target
    const value = input.value
    const id = input.dataset.id
    const scope = input.dataset.scope
    this.debug('saveName', { input, value, id, scope })
    if (!id || !scope) return

    if (scope.includes('activity.name')) {
      Rails.ajax({
        url: `/timer/activity/${id}`,
        type: 'PATCH',
        data: $.param({ scope, name: value }),
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
    console.log('AC', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }
}

export default Activity
