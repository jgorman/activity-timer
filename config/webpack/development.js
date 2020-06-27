process.env.NODE_ENV = process.env.NODE_ENV || "development"

const environment = require("./environment")

// Examine webpack-dev-server output.
const webpackConfig = environment.toWebpackConfig()
// console.log(webpackConfig)
// console.dir( webpackConfig, { depth: null })

// Inspect the webpackConfig
// debugger

module.exports = webpackConfig
