Template.battery.rendered = ->

  onVoltageChange = ({fromNumber, toNumber}) =>
    SearchQuery.set "average_voltage": {$gte: fromNumber, $lte: toNumber}
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

  onCapacityChange = ({fromNumber, toNumber}) =>
    SearchQuery.set "capacity_vol": {$gte: fromNumber, $lte: toNumber}

  $(".voltage-slider").ionRangeSlider 
    postfix: "V"
    min: 0
    max: 9
    onFinish: onVoltageChange  
    type: "double"
  
  $(".capacity-slider").ionRangeSlider 
    type: "double"
    min: 50
    max: 2000
    postfix: "Ah/L"
    onFinish: onCapacityChange
    step: .5
