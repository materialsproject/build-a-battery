@ElectrodesCollection = new Meteor.Collection("electrodes_timing")


if Meteor.isClient  
  Template.about.events 
    'click .about': ({target}) ->
      $("#about-content").toggle "blind", {
        easing: "easeInOutSine"}, 300

  Template.header.events
    "click .header": ({currentTarget}) ->
      $(currentTarget).toggleClass("active")

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
        onPointSelect: ({point}) -> 
          battery = {}
          point.select()
          for key, value of point.options
            battery[key] = if _.isNumber(value) then value.toFixed(2) else value
            if key is "color"
              battery[key] = value.replace "0.5", "1"
          Session.set "battery", battery



