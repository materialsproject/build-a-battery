Template.battery.rendered = ->
  Session.setDefault "anode", "graphite"

  onVoltageChange = ({fromNumber, toNumber}) =>
    SearchQuery.set "average_voltage": {$gte: fromNumber, $lte: toNumber}
    stable = fromNumber < 3
    unstable = fromNumber > 6
    mildUnstable = fromNumber > 3 and fromNumber < 6
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

Template.battery.events 
  "change .anode-select": ({currentTarget}) ->
    Session.set "anode", $(currentTarget).val()