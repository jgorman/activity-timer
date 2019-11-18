/*
 * Use the browser timezone hoisted up from a cookie.
 *
 * http://thisbythem.com/blog/clientside-timezone-detection/
 *
 * https://www.npmjs.com/package/jstimezonedetect
 * https://github.com/js-cookie/js-cookie
 *
 * See app/controllers/application_controller.rb
 */

var jstz = require('jstimezonedetect')
var Cookies = require('js-cookie')

$(function() {
  var tz = jstz.determine()
  Cookies.set('timezone', tz.name(), { path: '/' })
})
