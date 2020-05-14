# Keithley2260B
Sub-Class of SCPI_VoltageSource that will control the Keithley 2260B voltage source.

## Table of Contents
[TOC]

## Super Classes
[SCPI_VoltageSource][SCPI_VoltageSource]   
handle

## Methods (Super Overrides)
### Constructor
| Method | |
|--------|:--|
| Arguments | (String) visaVendor, (String) visaAddress |
| Output | [Keithley2260B][Keithley2260B] |
| Description | Sets all of the command strings in addition to the various super functionality. |
|||

### initSupply
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Turns the output off, then sets the output to 0 V, sets the supply to constant voltage mode with slew rate speed priority, turns the output on, and limits the output current to 250 mA.  |
|||

### setSlewedVoltage
| Method | |
|--------|:--|
| Arguments | (Float) outVoltage, (Float) slewRate |
| Output |  |
| Description | Sets the output to the given voltage at the given slew rate. Throws an error if the supply is not initialized. Blocks until supply is finished. |
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