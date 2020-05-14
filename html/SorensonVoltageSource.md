# SorensonVoltageSource 
SorensonVoltageSource Sub-Class of SCPI_VoltageSource that will control the Sorenson XG Series voltage sources. **After the completion of this class I was unable to connect the Sorenson voltage source to the computer successfully. It has has therefore NEVER BEEN TESTED; use with caution.**

## Table of Contents
[TOC]

## Methods (Super Overrides)
### Constructor
| Method | |
|--------|:--|
| Arguments | (String) visaVendor, (String) visaAddress |
| Output | [SorensonVoltageSource][SorensonVoltageSource] |
| Description | Runs super constructor and also sets the output voltage command as well as the output state command. |
|||

### initSupply
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Sets output to 0 V and turns output on. |
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