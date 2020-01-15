import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

let sc_id = 0

class ProjectSelect extends Controller {
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

    const keep = {}
    const $project_select = $(this.element)
    $project_select.on('show.bs.modal', event => this.keepScope(event, keep))
    $project_select.on('click', event => this.saveProject(event, keep))
  }

  disconnect() {
    this.debug('disconnect', { this: this })

    const $project_select = $(this.element)
    $project_select.off('show.bs.modal')
    $project_select.off('click')
  }

  // Keep the clicked element's scope and id.
  keepScope = (event, keep) => {
    const ds = event.relatedTarget.dataset
    if (!ds.scope) return
    keep.scope = ds.scope
    keep.activity_id = ds.activity_id
    keep.project_id = ds.project_id
    this.debug('keepScope', { keep })
  }

  htmlEscape = str => {
    return str
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
  }

  // Save selected project.
  saveProject = (event, keep) => {
    const ds = event.target.dataset
    const project_id = ds.project_id
    if (!project_id) return
    const scope = keep.scope
    if (!scope) return
    $('#project-select').modal('hide')
    this.debug('saveProject', { ds, scope, project_id, keep })

    if (scope.includes('activity.project')) {
      const activity_id = keep.activity_id
      if (!activity_id) return
      const url = window.RailsUrl(`/timer/activity/${activity_id}`)
      Rails.ajax({ type: 'PATCH', url, data: $.param({ scope, project_id }) })
    } else if (scope.includes('timer.project')) {
      const client_name = this.htmlEscape(ds.client_name || '')
      const project_name = this.htmlEscape(ds.project_name || '')
      const project_color = this.htmlEscape(ds.project_color || '')

      // Set the hidden form field.
      $('#timer_project_id').val(project_id)

      // Update the project display span.
      const $timer_project_display = $('#timer_project_display')
      $timer_project_display.html(`
        <div
          class="project-dot"
          style="background-color: ${project_color};">
        </div>
        <span style="color: ${project_color};">${project_name}</span>
        &nbsp;&bull; ${client_name}
      `)

      // Update the current timer if there is one.
      const timer_id = $timer_project_display.data('timer_id')
      if (!timer_id) return
      const url = window.RailsUrl('/timer/project')
      Rails.ajax({ type: 'POST', url, data: $.param({ project_id }) })
    }
  }

  debug = (msg, extra = '') => {
    if (!this.debugOn) return
    this.log(msg, extra)
  }

  log = (msg, extra = '') => {
    const id = this.element.id
    const pad = msg.length < 10 ? 10 - msg.length : 0
    console.log('PS', this.sc_id || 0, msg, ' '.repeat(pad), id, extra)
  }
}

export default ProjectSelect
