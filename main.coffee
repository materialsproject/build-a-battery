@Electrodes = new Meteor.Collection("electrodes")

if Meteor.isClient
  Template.main.rendered = ->
    @capacity = 10
    @voltage = 10

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
      refreshGauge voltage: fromNumber

    onCapacityChange = ({fromNumber}) ->
      refreshGauge capacity: fromNumber

    refreshGauge = ({voltage, capacity}) =>
      voltage ?= @voltage
      capacity ?= @capacity
      gauge.refresh(voltage * capacity)

    gauge = new JustGage
      id: "meter"
      value: @capacity * @voltage
      min: 0
      max: 3000
      title: "Battery Performance"
      label: "Energy Density"
      levelColors: "#E2591E #E8CC2D #AEE25D #20CD5A".split " "
    [ "titleFontColor", "valueFontColor", "showMinMax", "gaugeWidthScale", "gaugeColor", "label", "showInnerShadow", "shadowOpacity", "shadowSize", "shadowVerticalOffset", "levelColors", "levelColorsGradient", "labelFontColor", "startAnimationTime", "startAnimationType", "refreshAnimationTime", "refreshAnimationType"]

    $(".voltage-slider").ionRangeSlider 
      postfix: "V"
      onFinish: onVoltageChange  
    
    $(".capacity-slider").ionRangeSlider 
      postfix: "Ah/L"
      onFinish: onCapacityChange
      step: .5
      align:"vertical"
