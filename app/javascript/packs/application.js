/*
 * Rails startup.
 */

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')

/*
 * npm libraries.
 */

// If jQuery is not already registered in window.jQuery do it here.
window.jQuery = window.$ = require('jquery')

require('bootstrap')

// Stimulus setup.
import { Application } from 'stimulus'
const application = Application.start()

// Custom controllers.
import { definitionsFromContext } from 'stimulus/webpack-helpers'
const controllers = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(controllers))

// See https://github.com/jgorman/rails-form-validation
import Form from 'rails-form-validation'
application.register('form', Form)

/*
 * App setup.
 */

// https://github.com/webpack/docs/wiki/context
const requireAll = context => context.keys().map(context)
requireAll(require.context('../javascript', false, /\.(js|jsx)$/i))

require('../stylesheets')

const images = require.context('../images', false, /\.(png|svg|jpg)$/i)
