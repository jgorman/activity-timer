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


