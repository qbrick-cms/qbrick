/* no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "../css/application.css"

require("@rails/ujs").start()

var ActionCable = require('actioncable')

var cable = ActionCable.createConsumer('wss://RAILS-API-PATH.com/cable')

//document.getElementsByClassName("js-dropdown").forEach((button) => {
  //button.addEventListener('click', (event) => {
    //console.log(button)
  //})
//})

//cable.subscriptions.create('AppearanceChannel', {
  //// normal channel code goes here...
//});

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /.js$/)
application.load(definitionsFromContext(context))
