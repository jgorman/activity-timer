var jstz = require('jstimezonedetect')
var Cookies = require('js-cookie')

$(function() {
  var tz = jstz.determine()
  Cookies.set('timezone', tz.name(), { path: '/' })
})
