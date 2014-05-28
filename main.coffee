@ElectrodesCollection = new Meteor.Collection("electrodes")


if Meteor.isClient
  Template.about.events 
    'click .about': ({target}) ->
      $("#about-content").toggle "blind", {
        easing: "easeInOutSine"}, 300

