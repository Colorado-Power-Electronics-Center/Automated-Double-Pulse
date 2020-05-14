# SwitchWaveform
The SwitchWaveform class is used to store only the waveforms of the individual switching events. It can store either a turn off or a turn on waveform.
## Table of Contents
[TOC]

## Super Classes
[GeneralWaveform][GeneralWaveform]   
handle

## Properties (Constant)
### TURN_ON
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'turn_on'</code> |
| Type | String |
| Units |  |
| Description | String used in determining switching event. |
|||

### TURN_OFF
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'turn_off'</code> |
| Type | String |
| Units |  |
| Description | String used in determining switching event. |
|||

## Properties
### switchCapture
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Indicates whether the object is storing the turn on or turn off waveform. |
|||

### switchIdx
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units |  |
| Description | Number representing the index where the switch occurs. This is an approximate value and should not be relied upon for accurate timing.  |
|||

## Methods
### Constructor
| Method | |
|--------|:--|
| Arguments | (Float Array) v_ds, (Float Array) v_gs, (Float Array) i_d, (Float Array) i_l, (Float Array) time, (String) switchCapture |
| Output | [SwitchWaveform][SwitchWaveform] |
| Description | Creates a new SwitchWaveform object from arrays of each waveform. The channel property inherited from [GeneralWaveform][GeneralWaveform] is instantiated with the default [channelMapper][channelMapper] properties. The final argument, switchCapture, determines whether the switching even is turn on or turn off. Can be either of the two constant values defined [above](#properties-constant).|
|||

### isTurnOn
| Method | |
|--------|:--|
| Arguments |  |
| Output | Boolean |
| Description | Returns true if turn on waveform or false if turn off waveform. |
|||



[channelMapper]: channelMapper.html
[checkLoadInductor]: checkLoadInductor.html
[DoublePulseResults]: DoublePulseResults.html
[Double_Pulse_Test]: Double_Pulse_Test.html
[DPTSettings]: DPTSettings.html
[extractWaveforms]: extractWaveforms.html
[extract_turn_on_waveform]: extract_turn_on_waveform.html
[findDeskew]: findDeskew.html
[FullWaveform]: FullWaveform.html
[GeneralWaveform]: GeneralWaveform.html
[Keithley2260B]: Keithley2260B.html
[min2Scale]: min2Scale.html
[processWaveform]: processWaveform.html
[pulse_generator]: pulse_generator.html
[rescaleAndRepulse]: rescaleAndRepulse.html
[runDoublePulseTest]: runDoublePulseTest.html
[SCPI_FunctionGenerator]: SCPI_FunctionGenerator.html
[SCPI_Instrument]: SCPI_Instrument.html
[SCPI_Oscilloscope]: SCPI_Oscilloscope.html
[SCPI_VoltageSource]: SCPI_VoltageSource.html
[SettingsSweepObject]: SettingsSweepObject.html
[setVoltageToLoad]: setVoltageToLoad.html
[SimpleSettings]: SimpleSettings.html
[SorensonVoltageSource]: SorensonVoltageSource.html
[splitWaveforms]: splitWaveforms.html
[SurfacePlotSettings]: SurfacePlotSettings.html
[SweepPlotSettings]: SweepPlotSettings.html
[SweepResults]: SweepResults.html
[SwitchWaveform]: SwitchWaveform.html
[waveformTimeIdx]: waveformTimeIdx.html
[WindowSize]: WindowSize.html