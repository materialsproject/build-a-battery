@ElectrodesCollection = new Meteor.Collection("electrodes")


if Meteor.isClient
  Template.about.events 
    'click .about': ({target}) ->
      $("#about-content").toggle "blind", {
        easing: "easeInOutSine"}, 300

  Template.battery.rendered = ->
    @capacity = 10
    @voltage = 10
    @anode = new Electrode name: "graphite"

    onVoltageChange = ({fromNumber, toNumber}) =>
      Session.set "voltage", {gte: fromNumber, lte: toNumber}
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
      @voltage = fromNumber
      refreshGauge {@voltage}

    onCapacityChange = ({fromNumber, toNumber}) =>
      @capacity = fromNumber
      refreshGauge {@capacity}

    refreshGauge = ({voltage, capacity}) =>
      voltage ?= @voltage
      capacity ?= @capacity
      gauge.refresh(voltage * capacity)

    gauge = new JustGage
      id: "meter"
      value: @capacity * @voltage
      min: 0
      max: 10000
      title: "Battery Performance"
      label: "Energy Density"
      levelColors: "#E2591E #E8CC2D #AEE25D #20CD5A".split " "
    [ "titleFontColor", "valueFontColor", "showMinMax", "gaugeWidthScale", "gaugeColor", "label", "showInnerShadow", "shadowOpacity", "shadowSize", "shadowVerticalOffset", "levelColors", "levelColorsGradient", "labelFontColor", "startAnimationTime", "startAnimationType", "refreshAnimationTime", "refreshAnimationType"]

    $(".voltage-slider").ionRangeSlider 
      postfix: "V"
      onFinish: onVoltageChange  
      type: "double"
    
    $(".capacity-slider").ionRangeSlider 
      type: "double"
      postfix: "Ah/L"
      onFinish: onCapacityChange
      step: .5
