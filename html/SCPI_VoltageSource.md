# SCPI_VoltageSource
SCPI_VoltageSource is a Sub-Class of SCPI_Instrument for use with Voltage Sources. Currently the class requires the use of a sub class to control various functions. This class describes functions that can be implemented, but will throw an error if they are not implemented within the sub class. The class was designed in this way to ensure that no commands are assumed to be known, because of the potential of power supplies to cause real damage to the user or equipment. 

## Table of Contents
[TOC]

## Properties
### outVoltageCmd
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Command that should be sent to the power supply to change the output voltage. |
|||

### outCurrentCmd
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Command that should be sent to the power supply to set the output current. |
|||

### outputStateCmd
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Command that should be sent to the power supply to change the output state. |
|||


### outputModeCmd
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Command that should be sent to the power supply to change the output mode. |
|||


### voltageSlewRisingCmd
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Command that should be sent to the power supply to change the rising voltage slew rate. |
|||


### voltageSlewFallingCmd
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Command that should be sent to the power supply to change the falling voltage slew rate. |
|||


### initialized
| Properties | |
|---------|:--|
| Default Value | false |
| Type | Boolean |
| Units |  |
| Description | If the scope has been initialized this value should be set to true. SHould be false if not yet initialized or if for some reason brought out of the initialized state. |
|||

## Properties (Dependent)
### outVoltage
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Volts |
| Description | Power Supply's output voltage. |
|||

### outCurrent
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Amps |
| Description | Power Supply's output current (limit).  |
|||

### outputState
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Power Supply's output state. <code class="prettyprint lang-MATLAB">{'ON' \| 'OFF'}</code> |
|||

### outputMode
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Power Supply's output mode. |
|||

### voltageSlewRising
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Volts / second |
| Description | Power Supply's rising voltage slew rate.  |
|||

### voltageSlewFalling
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Volts / second |
| Description | Power Supply's falling voltage slew rate. |
|||

## Methods (Private, Static)
### notImplemented
| Method | |
|--------|:--|
| Arguments | (String) funcName |
| Output | (String) str |
| Description | Appends the string <code class="prettyprint lang-MATLAB">' not implemented for this power supply'</code> to the given string and returns the result. |
|||

## Methods 
### Constructor
| Method | |
|--------|:--|
| Arguments | (String) visaVendor, (String) visaAddress |
| Output | [SCPI_VoltageSource][SCPI_VoltageSource] |
| Description | Same as parent class, [SCPI_Instrument][SCPI_Instrument]. |
|||

## Control Methods
These functions must be implemented in the class for the individual power supply. If called and not implemented an error will be thrown. The methods in this category do not do anything other than throw errors, they must be implemented in the subclass for each specific power supply.

### initSupply
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | This method should set the power supply up in a way that allows the supply to receive commands for changing the voltage, current, output state, etc and have them behave in whatever way is desirable for the given application. It should also set the initialized parameter to true when finished. In most applications it is probably desirable to ensure the supply is **not** energized after this method is finished.|
|||

### setSlewedVoltage
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | This method should set the rising and falling slew rates as desired and ensure that the supply is set up to use them. |
|||

## Stop Methods
### outputOffZero
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | This method is meant to be used when some error in the code or operation requires the circuit to be rapidly de-energized. It turns the supply's output off, then sets the output voltage to 0, and then finally declares the supply as not initialized. |
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