# require bootstrap
#= require_self
#= require_tree ./views

$ ->
  $('.qbrick-text-brick').each ->
    new ReadMoreView($(this))
