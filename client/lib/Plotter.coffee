class @Plotter 
  constructor: ({@collection, @xAxis, @yAxis}) ->
    @draw @collection

  draw: (@collection) ->
    @plot = new Highcharts.Chart
      chart:
        renderTo: "results-plot"
        type: "scatter"
        zoomType: 'xy'
        height: 500
        width: 800
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
        useHTML: true
        formatter: ->
          header = "<b class='tooltip-formula'>#{@point.options.formula}</b><br>"
          pointFormat = "<b>#{@point.options.xAxis}:</b> #{@point.x.toFixed(2)} <br/> 
                        <b>#{@point.options.yAxis}:</b> #{@point.y.toFixed(2)} <br/> 
                        <b>Chempot:</b> #{@point.options.chempot.toFixed(2)}
                        "
          header+pointFormat
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
      xAxis: @prettyName @xAxis
      yAxis: @prettyName @yAxis
      color: @getPointColor chempot
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

  getPointColor: (chempot) ->
    color = switch 
      when chempot > -5.8 and chempot < -4.8
        "rgba(210, 182, 59, 0.5)"
      when chempot < -5.8 then "rgba(98, 158, 129, 0.5)"
      when chempot > -4.8 then "rgba(237, 103, 101, 0.5)"
    color

