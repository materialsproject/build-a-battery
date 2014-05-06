if Meteor.isClient
  Template.battery.greeting = ->
    "Welcome to build-a-battery."

  Template.battery.rendered = ->
    $(".slider").ionRangeSlider()

  Template.battery.events 
    'click input': ->
      # // template data, if any, is available in 'this'

if Meteor.isServer 
  Meteor.startup ->
