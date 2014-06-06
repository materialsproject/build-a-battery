class @Plotter 
  constructor: ({@collection, @xAxis, @yAxis, @onPointSelect}) ->
    @colors = 
      red: "rgba(237, 103, 101, 0.5)"
      yellow: "rgba(210, 182, 59, 0.5)"
      green: "rgba(98, 158, 129, 0.5)"
    @draw @collection

  draw: (@collection) ->
    @plot = new Highcharts.Chart
      chart:
        renderTo: "results-plot"
        type: "scatter"
        zoomType: 'xy'
        height: 400
        width: 700
        style: fontFamily: "Helvetica, arial"
      legend: 
        enabled:false
      title: text: ""
      xAxis:
        title:
          enabled: true
          text: @prettyName @xAxis
        startOnTick: true
        endOnTick: true
        showLastLabel: true
        plotBands: [
            color: "rgba(237, 103, 101, 0.2)"
            from: 0.1
            to: Infinity 
        , 
            color: "rgba(244, 223, 142, 0.4)"
            from: 0.05
            to: 0.1
        ,
          color: "rgba(162, 244, 193, 0.3)"
          from: -Infinity
          to: 0.05
        ]
      yAxis:
        min: 0
        title:
          text: @prettyName @yAxis
        plotLines: [
          color: "#5EAFEF"
          width: 3
          value: 110
          zIndex: 5
          label:
            text: "Tesla Li-ion car battery pack"
            style: 
              fontWeight: "bold" 
        ,
          color: "#63AE87"
          width: 3
          value: 200
          zIndex: 5
          label: 
            text: "Advanced Li-ion"
            style: fontWeight: "bold"
        ,
          color: "#6361AE"
          width: 3
          value: 400
          zIndex: 5
          label: 
            text: "Magnesium-ion"
            style: fontWeight: "bold"
        ,
          color: "#ED6765"
          width: 3
          value: 50
          zIndex: 5
          label: 
            text: "Lead-Acid"
            style: fontWeight: "bold"
        ]
      credits: enabled: false
      tooltip:
        enabled: false
      plotOptions:
        scatter:
          marker:
            radius: 5
            symbol: "circle"
            states:
              hover:
                enabled: true
                lineColor: "rgb(100,100,100)"
          states:
            hover:
              marker:
                enabled: false
        series: 
          events:
            click: @onPointSelect 
          marker: states: select:
            lineColor: "#6AAAC5" 
            fillColor: "#88CBE3"
            radius:8
      series: [@createSeries()]

  htmlFormula: (formula) ->
    htmlFormula = formula.replace(/([A-Z][a-z]*)([\d\.]+)/g, "$1<sub>$2</sub>")
    htmlFormula = htmlFormula.replace(/(\))([\d\.]+)/g, "$1<sub>$2</sub>")

  createSeries: ->
    data: @collection.map (battery) =>
      chempot = @getChempot battery.muO2_data
      x: battery[@xAxis]
      y: battery[@yAxis]
      formula: @htmlFormula battery.formula_discharge
      chempot: chempot
      voltage: battery.average_voltage
      xAxis: @prettyName @xAxis
      yAxis: @prettyName @yAxis
      cpuTime: @toHHMMSS battery.total_cpu_time
      color: @getPointColor chempot, battery.average_voltage
    name: "materials"

  prettyName: (str) ->
    str.charAt(0).toUpperCase() + str.substring(1).replace(/_(\w)/g, (match, p1) -> " " + p1.toUpperCase())

  getChempot: (muO2) ->
    chempots = []
    for id, nodes of muO2
      {chempot} = _.find nodes, ({evolution}) ->
        evolution < 0
      chempots.push chempot
    _.max chempots

  getPointColor: (chempot, voltage) ->
    color = switch 
      when voltage > 4.8 then @colors.red
      when chempot > -5.8 and chempot < -4.8
        @colors.yellow
      when chempot < -5.8 then @colors.green
      when chempot > -4.8 then @colors.red
    color

  toHHMMSS: (seconds) ->
    seconds = Math.floor seconds
    seconds = parseInt(seconds, 10) 
    hours = Math.floor(seconds / 3600)
    minutes = Math.floor((seconds - (hours * 3600)) / 60)
    seconds = seconds - (hours * 3600) - (minutes * 60)
    hours = "0" + hours  if hours < 10
    minutes = "0" + minutes  if minutes < 10
    seconds = "0" + seconds  if seconds < 10
    time = hours + ":" + minutes + ":" + seconds
    time
