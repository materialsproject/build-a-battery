class @CellModel
  """
    Model an entire cell
    :param anode: Electrode object
    :param cathode: Electrode object
    :param mass_frac: mass fraction of battery that is electrodes (0-1)
    :param vol_frac: volume fraction of battery that is electrodes (0-1)
  """
  constructor: ({@anode, @cathode, @massFrac, @volFrac}) ->
    @massFrac ?= 0.54
    @volFrac ?= 0.46
    @cellVoltage = @cathode.voltage - @anode.voltage
    @cellCapGrav = @massFrac / (1 / @anode.cap_grav + 1 / @cathode.cap_grav)
    @cellCapVol = @volFrac / (1 / @anode.cap_vol + 1 / @cathode.cap_vol)
    @cellEDensGrav =  @cellCapGrav * @cellVoltage
    @cellEDensVol = @cellCapVol * @cellVoltage


