/*
 * Rails startup.
 */

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

/*
 * npm libraries.
 */

// If jQuery is not already registered in window.jQuery do it here.
window.jQuery = window.$ = require('jquery')

require('bootstrap')

/*
 * App setup.
 */

// https://github.com/webpack/docs/wiki/context
const requireAll = context => context.keys().map(context)

requireAll(require.context('../javascript', false, /\.(js|jsx)$/i))

require('../stylesheets')

const images = require.context('../images', false, /\.(png|svg|jpg)$/i)
