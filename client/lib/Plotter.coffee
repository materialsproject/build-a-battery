class @Plotter 
  constructor: ({@collection, @xAxis, @yAxis}) ->
    @draw @collection

  draw: (@collection) ->
    @plot = new Highcharts.Chart
      chart:
        renderTo: "results-plot"
        type: "scatter"
        zoomType: 'xy'
        height: 400
        width: 640
        style: fontFamily: "Helvetica, arial"
      legend: 
        align: "right"
        layout: "vertical"
        verticalAlign: 'top'
        x: 0
        y: 50
        itemHoverStyle: color: "#848485"
        itemHiddenStyle: color: "#A2A2A3"
        itemStyle: color: "royalblue"
      title: text: ""
      xAxis:
        title:
          enabled: true
          text: @prettyName @xAxis
        startOnTick: true
        endOnTick: true
        showLastLabel: true
      yAxis:
        title:
          text: @prettyName @yAxis
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

    