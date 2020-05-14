# pulse_generator
The pulse_generator function generates an array of points from a list of times that can be given to a function generator to output an arbitrary pulse waveform.

## Table of Contents
[TOC]

## Methods
### pulse_generator
| Method | |
|--------|:--|
| Arguments | (Float) sampleRate, (Float or Float Array) times, Optional (Unlimited): (Float) times  |
| Output | (Integer Array) pulse_waveform, (Float) total_time |
| Description | Function takes in a sample rate and a list of times in order to create an arbitrary pulse train. The function has two ways of supply the times of the pulse train. The first is to supply an array of all times (e.g. [1, 2, 1, 2, 4]) as the 2nd argument. The second is to supply an unlimited number of arguments to supply the times (e.g. pulse_generator(sampleRate, 1, 2, 1, 2, 4)). In either case the times should be given in seconds and the first number in the list is the initial dead time (meaning in our previous example a pulse will be generated with 1 second off, 2 seconds on, 1 off, 2 on, 4 off). An argument of 0 may be given at any time to put to skip a particular on or off period.  |
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