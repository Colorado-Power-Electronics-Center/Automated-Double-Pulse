# FullWaveform
The FullWaveform class is used to store the complete waveform. It also contains functionality to split the waveform into the two switching events. 
## Table of Contents
[TOC]

## Super Classes
[GeneralWaveform][GeneralWaveform]       
handle

## Properties
### turn_on_idx
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units |  |
| Description | Index in the waveform where the turn on occurs. This value is approximate and should not be used for precise timing. It is calculated in the [extractSwitches](#extractswitches) method. |
|||

### turn_off_idx
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units |  |
| Description |  Index in the waveform where the turn off occurs. This value is approximate and should not be used for precise timing. It is calculated in the [extractSwitches](#extractswitches) method.  |
|||


### turnOnWaveform
| Properties | |
|---------|:--|
| Default Value |  |
| Type | [SwitchWaveform][SwitchWaveform] |
| Units |  |
| Description | The extracted turn on waveform. Created during the [extractSwitches](#extractswitches) method. |
|||

### turnOffWaveform
| Properties | |
|---------|:--|
| Default Value |  |
| Type | [SwitchWaveform][SwitchWaveform] |
| Units |  |
| Description | The extracted turn off waveform. Created during the [extractSwitches](#extractswitches) method. |
|||

### windowSize
| Properties | |
|---------|:--|
| Default Value |  |
| Type | [WindowSize][WindowSize] |
| Units |  |
| Description | Window size used to determine the length of the turn on and turn off waveforms. |
|||

## Methods (Private)
### extractSwitches
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Extracts the turn on and turn off waveforms and stores them in the [turnOnWaveform](#turnonwaveform) and [turnOffWaveform](#turnoffwaveform) objects.  |
|||

### sectionWaveform
| Method | |
|--------|:--|
| Arguments | (String) switchCapture |
| Output | ([SwitchWaveform][SwitchWaveform]) sectionedWF |
| Description | Sections either the turn on or the turn off waveform from the base waveform as specified by the switchCapture argument. It is recommended to use [SwitchWaveforms][SwitchWaveform] TURN_ON and TURN_OFF properties for the argument. This method is called by the [extractSwitches](#extractswitches) method. |
|||

## Methods (Static)
### fromChannelCell
| Method | |
|--------|:--|
| Arguments | (Cell Array) waveforms, ([channelMapper][channelMapper]) channels, (float) busVoltage, ([windowSize][windowSize]) windowSize |
| Output | ([FullWaveform][fullWaveform]) FW |
| Description | Creates a fullWaveform object from a cell array of waveforms and the settings associated with their capture.  |
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