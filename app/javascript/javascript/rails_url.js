// Javascript ajax calls Rails running in a sub-uri.

const relative_url_root =
  $('meta[name=relative-url-root]').attr('content') || ''

window.RailsUrl = url => `${relative_url_root}${url}`
