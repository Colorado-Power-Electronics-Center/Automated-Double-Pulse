# General Waveform
## Table of Contents
[TOC]

## Super Classes
handle

## Properties
### approxBusVoltage
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units | Volts |
| Description | Value for the approximate Bus Voltage of the Waveform. Used to section waveform and for graphing purposes.  |
|||

### v_ds
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float Array |
| Units | Volts |
| Description | Array of the measured $V_{DS}$. |
|||

### v_gs
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float Array |
| Units | Volts |
| Description | Array of the measured $V_{GS}$. |
|||

### i_d
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float Array |
| Units | Amps |
| Description | Array of the measured $I_D$. |
|||

### i_l
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float Array |
| Units | Amps |
| Description | Array of the measured inductor current. |
|||

### v_sync
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float Array |
| Units | Volts |
| Description | Array of the measured voltage across the synchronous device. |
|||

### time
|Properties | |
|---------|:--|
|Default Value |  |
|Type | float Array |
|Units | Seconds |
|Description | Array of time associated with the other waveforms. |
|||

### channel
|Properties | |
|---------|:--|
|Default Value |  |
|Type | [channelMapper][channelMapper] |
|Units |  |
|Description | Channel Mapper used to associate waveforms with their oscilloscope channels. |
|||

### channelOrderedCell
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Cell Array (Float) |
| Units | Multiple |
| Description | Cell array of all waveforms in the order given in [channel](#channel). |
|||


## Properties (Dependent)
### sampleRate
|Properties | |
|---------|:--|
|Default Value |  |
|Type | Float |
|Units | Hertz |
|Description | Sample rate of the measured data. Calculated using the [time](#time) array.  |
|||

### samplePeriod
|Properties | |
|---------|:--|
|Default Value |  |
|Type | Float |
|Units | Seconds |
|Description | Sample period of the measured data. Calculated using the [time](#time) array. |
|||

## Methods
### Constructor
| Method | |
|--------|:--|
| Arguments | (Float Array) v_ds, (Float Array) v_gs, (Float Array) i_d, (Float Array) i_l, (Float Array) time |
| Output | GeneralWaveform |
| Description | Creates a new GeneralWaveform object from arrays of each waveform. The channel property is instantiated with the default [channelMapper][channelMapper] properties. |
|||

### chCell
| Method | |
|--------|:--|
| Arguments |  |
| Output | Cell array |
| Description | Getter method for [channelOrderedCell](#channelOrderedCell). Result is cached after method is run for the first time and therefore changes to object properties after not reflected in the channel ordered cell unless the [channelOrderedCell](#channelOrderedCell) is set to empty (e.g. <code class="prettyprint lang-MATLAB">GeneralWaveformObj.channelOrderedCell = {};</code>).   |
|||

## Methods (Static)
### fromChannelCell
| Method | |
|--------|:--|
| Arguments | (Class) class, (Cell Array) waveforms, ([channelMapper][channelMapper]) channels |
| Output | (class) GW |
| Description | Creates an object of type "class," with waveforms given by the channel ordered cell "waveforms," and with channels given by the channelMapper parameter channels. Class can be any Class that inherits GeneralWaveform; however, in the Double_Pulse_Test program this is either [FullWaveform][FullWaveform] or [SwitchWaveform][SwitchWaveform].  |
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