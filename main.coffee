@Electrodes = new Meteor.Collection("electrodes")

if Meteor.isClient
  Template.battery.greeting = ->
    "Welcome to build-a-battery."

  Template.battery.rendered = ->
    onVoltageChange = ({fromNumber}) ->
      stable = fromNumber < 30
      unstable = fromNumber > 60
      mildUnstable = fromNumber > 30 and fromNumber < 60
      $batt = $ ".battery"
      if stable 
        $batt.removeClass "shake shake-vertical shake-little"
      else if mildUnstable   
        $batt
          .addClass "shake shake-little"
          .removeClass "shake-vertical"
      else if unstable
        $batt.addClass "shake shake-vertical"

    $(".slider").ionRangeSlider 
      postfix: "V"
      onFinish: onVoltageChange  

  Template.battery.events 
    'click input': ->
      # // template data, if any, is available in 'this'

if Meteor.isServer 
  Meteor.startup ->

