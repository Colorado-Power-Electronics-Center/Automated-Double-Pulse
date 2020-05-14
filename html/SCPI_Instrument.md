# SCPI_Instrument
The SCPI_Instrument class is the super class used for control of all measurement equipment. It contains methods that all instruments need, including connection, sending commands arbitrary commands, sending specific common commands, and more. It is inherited by many specific classes to prevent code duplication.

## Table of Contents
[TOC]

## Super classes
handle

## Properties
### visaAddress
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Contains the visa address for an instrument. |
|||

### visaVendor
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Contains the string indicating what flavor of VISA should be used to communicate with the instrument. Uses a setter method to change value that prevents invalid values from being used. The only options at this time are <code class="prettyprint lang-MATLAB">['tek' 'agilent' 'ni']</code>. Unless given otherwise, a value of <code class="prettyprint lang-MATLAB">'agilent'</code>, is generally sufficient.  |
|||


### visaObj
| Properties | |
|---------|:--|
| Default Value |  |
| Type | visa |
| Units |  |
| Description | Visa object used to communicate with the instrument. Created with the [createVisaObj](#createvisaobj) method. |
|||


### connected
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Boolean |
| Units |  |
| Description | If MATLAB is connected to the instrument this property will be true. If not connected will be false. This value is not automatically detected and if an error causes a disconnect it may not be accurate.  |
|||


### typeStr
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'Instrument'</code> |
| Type | String |
| Units |  |
| Description | String defining what type of instrument the object represents. Currently not well implemented, but is only used in Error messages. |
|||


### commandDelay
| Properties | |
|---------|:--|
| Default Value | 50 ms |
| Type | Float |
| Units | Seconds |
| Description | Delay between each command. This is theoretically not necessary, but when communicating with multiple instruments it can be helpful. Generally, data transfer is the limiting factor in operation time so a small delay between commands is negligible. |
|||

## Methods

### Constructor
| Method | |
|--------|:--|
| Arguments | (String) visaVendor, (String) visaAddress |
| Output | [SCPI_Instrument][SCPI_Instrument] |
| Description | Creates SCPI_Instrument object from given vendor and address. Also creates visa object.|
|||

### createVisaObj
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Creates the visa object. Called by the [constructor](#constructor). |
|||


### clearVisaObj
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Deletes the visa object. |
|||


### connect
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Connects to the Instrument. |
|||


### disconnect
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Disconnects from the Instrument. |
|||


### sendCommand
| Method | |
|--------|:--|
| Arguments | (String) command |
| Output |  |
| Description | Sends command to the instrument if connected. |
|||


### readResponse
| Method | |
|--------|:--|
| Arguments |  |
| Output | (String) out |
| Description | Reads the output of the instrument if connected and returns the string value. |
|||


### query
| Method | |
|--------|:--|
| Arguments | (String) query |
| Output | (String) out |
| Description | Sends command to instrument and returns the response if connected. |
|||


### numQuery
| Method | |
|--------|:--|
| Arguments | (String) queryStr |
| Output | (Double) out |
| Description | Sends command to instrument and returns the response as a double if connected. |
|||


### binBlockQuery
| Method | |
|--------|:--|
| Arguments | (String) query, (String) precision |
| Output | (Varies) out |
| Description | Sends command and returns binary block response if connected. Refer to instrument documentation for commands that support this method. Precision is "The number of bits read for each value, and the interpretation of the bits as character, integer, or floating-point values." (See binblockread and fread MATLAB documentation for more details.) |
|||


### reset
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Sends the <code class="prettyprint lang-MATLAB">'*RST'</code> to the instrument. Generally sets the instrument to factory default settings. Typically used to set the instrument to a known state.  |
|||


### trigger
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Sends the <code class="prettyprint lang-MATLAB">'*TRG'</code> command to the instrument. What this does depends on the instrument and settings. |
|||


### push2Trigger
| Method | |
|--------|:--|
| Arguments | (String \| Boolean) triggerStr, (Boolean) push2pulse |
| Output |  |
| Description | Works similarly to the [trigger](#trigger) function; however, it includes additional functionality that can ask a user to confirm before continuing with the operation. If triggerStr is given the message presented to the user will be <code class="prettyprint lang-MATLAB">['Push any button to ' triggerStr '...']</code> if not given triggerStr will default to <code class="prettyprint lang-MATLAB">'trigger'</code>. Either argument may be skipped if desired. (i.e. <code class="prettyprint lang-MATLAB">obj.push2Trigger('pulse', true)</code>, <code class="prettyprint lang-MATLAB">obj.push2Trigger(true)</code>, and <code class="prettyprint lang-MATLAB">obj.push2Trigger('pulse')</code> are all valid function calls. |
|||


### clearStatus
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Sends the <code class="prettyprint lang-MATLAB">'*CLS'</code> command to the instrument. This will clear any errors found in the instruments error register.  |
|||


### identity
| Method | |
|--------|:--|
| Arguments |  |
| Output | (String) out |
| Description | Requests and returns the value of the instrument's identity. Typically a string containing manufacture and model number information. |
|||


### operationComplete
| Method | |
|--------|:--|
| Arguments |  |
| Output | (String) out |
| Description | "Returns an ASCII "+1" when all pending overlapped operations have been completed." |
|||


## Methods (Static)
### U2Str
| Method | |
|--------|:--|
| Arguments | (String \| number) UStr |
| Output | (String) out |
| Description | Converts an unknown variable type to a string. Allows arguments to be accepted as both numbers and strings and be correctly converted to a string for sending to the instrument.|
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