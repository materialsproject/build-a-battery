@ElectrodesCollection = new Meteor.Collection("electrodes")


if Meteor.isClient  
  Template.about.events 
    'click .about': ({target}) ->
      $("#about-content").toggle "blind", {
        easing: "easeInOutSine"}, 300

  Meteor.autorun ->
    batteries = ElectrodesCollection
      .find(Session.get("query"), limit:999)
    batteries = batteries.map (batt) ->
      anode = new Electrode name: Session.get("anode")
      cathode = new Electrode
        capVol: batt.capacity_vol
        capGrav: batt.capacity_grav
        voltage: batt.average_voltage
      cellModel = new CellModel {anode, cathode}
      batt.e_density = cellModel.cellEDensGrav
      batt
    if @plotter?
      @plotter.draw batteries
    else if not _.isEmpty batteries
      @plotter = new Plotter 
        collection: batteries
        yAxis: "e_density"
        xAxis: "max_instability"



