class @Electrode
  constructor: ({@voltage, @capGrav, @capVol, @name}) ->
    presets = "Li graphite Si Li4Ti5O12".split " "
    if @name? and @name in presets
      @setPresets()
    # density in g/cc
    @density = @capGrav / @capVol

  setPresets: ->
    [@voltage, @capGrav, @capVol] = switch @name
      when "Li" then [0, 3861, 2062]
      when "graphite" then [0.1, 310, 700]
      when "Si" then [0.37, 1200, 1500]
      when "Li4Ti5O12" then [1.5, 175, 591.5]