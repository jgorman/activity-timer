/*
 * Rails startup.
 */

// If jQuery is not already registered in window.jQuery do it here.
window.jQuery = window.$ = require("jquery")

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

/*
 * npm libraries.
 */

require("bootstrap")

// Stimulus setup.
import { Application } from "stimulus"
const application = Application.start()

// See https://github.com/jgorman/rails-form-validation
import Form from "rails-form-validation"
application.register("form", Form)

// Custom controllers.
import { definitionsFromContext } from "stimulus/webpack-helpers"
const controllers = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(controllers))

/*
 * App setup.
 */

const javascripts = require.context("../javascript", false, /\.(js|jsx)$/i)
javascripts.keys().forEach(javascripts)

require.context("../images", false, /\.(png|svg|jpg)$/i)

require("../stylesheets")

require("../channels")

/*
 * React on Rails
 */

import ReactOnRails from "react-on-rails"

import YohWorld from "../components/YohWorld"

// This is how react_on_rails can see the YohWorld in the browser.
ReactOnRails.register({
  YohWorld,
})
