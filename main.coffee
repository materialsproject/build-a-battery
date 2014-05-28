@ElectrodesCollection = new Meteor.Collection("electrodes")


if Meteor.isClient  
  Template.about.events 
    'click .about': ({target}) ->
      $("#about-content").toggle "blind", {
        easing: "easeInOutSine"}, 300

  Meteor.autorun ->
    ElectrodesCollection
      .find(Session.get("query"), limit:200)
      .fetch()
