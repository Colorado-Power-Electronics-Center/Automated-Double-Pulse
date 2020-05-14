# DPTSettings
The DPTSettings class stores the settings that control the operation of the double pulse test. It contains a number of settings, many of which have default values, that can be altered to customize the operation of the toolbox. 

## Table of Contents
[TOC]

## Default Values
### Test Specific Settings
|Setting | Default Value |
|--------|---------------:|
| [`busVoltages`](#busvoltages) | |
| [`loadCurrents`](#loadcurrents) | |
| [`currentResistor`](#currentresistor) | |
| [`loadInductor`](#loadinductor) | |
| [`minGateVoltage`](#mingatevoltage) | <code class="prettyprint lang-MATLAB">0</code>|
| [`maxGateVoltage`](#maxgatevoltage) | |
| [`gateLogicVoltage`](#gatelogicvoltage) | |
| [`channel.VDS`](#channelvds) | |
| [`channel.VGS`](#channelvgs) | |
| [`channel.ID`](#channelid) | |
| [`channel.IL`](#channelil) | |
|||

### Instrument Setup
|Setting | Default Value |
|--------|---------------:|
| [`FGen_buffer_size`](#fgen_buffer_size) | <code class="prettyprint lang-MATLAB">6000000</code> |
| [`Scope_Buffer_size`](#scope_buffer_size) | <code class="prettyprint lang-MATLAB">200000</code>|
| [`Bus_Supply_buffer_size`](#bus_supply_buffer_size) | <code class="prettyprint lang-MATLAB">200000</code>|
| [`scopeVisaAddress`](#scopevisaaddress) | |
| [`FGenVisaAddress`](#fgenvisaaddress) | |
| [`BusSupplyVisaAddress`](#bussupplyvisaaddress) | |
| [`scopeVendor`](#scopevendor) | <code class="prettyprint lang-MATLAB">'tek'</code>|
| [`FGenVendor`](#fgenvendor) | <code class="prettyprint lang-MATLAB">'agilent'</code>|
| [`BusSupplyVendor`](#bussupplyvendor) | <code class="prettyprint lang-MATLAB">'agilent'</code>|
| [`scopeTimeout`](#scopetimeout) | <code class="prettyprint lang-MATLAB">10</code>|
| [`scopeByteOrder`](#scopebyteorder) | <code class="prettyprint lang-matlab">'littleEndian'</code>|
|||

### Pulse Creation
|Setting | Default Value |
|--------|---------------:|
| [`pulse_lead_dead_t`](#pulse_lead_dead_t) | <code class="prettyprint lang-MATLAB">1e-6</code> |
| [`pulse_off_t`](#pulse_off_t) | <code class="prettyprint lang-MATLAB">5e-6</code> |
| [`pulse_second_pulse_t`](#pulse_second_pulse_t) | <code class="prettyprint lang-MATLAB">5e-6</code> |
| [`pulse_end_dead_t`](#pulse_end_dead_t) | <code class="prettyprint lang-MATLAB">1e-6</code> |
| [`use_mini_2nd_pulse`](#use_mini_2nd_pulse) | <code class="prettyprint lang-MATLAB">false</code> |
| [`mini_2nd_pulse_off_time`](#mini_2nd_pulse_off_time) | <code class="prettyprint lang-MATLAB">50e-9</code> |
| [`burstMode`](#burstmode) | <code class="prettyprint lang-MATLAB">'TRIGgered'</code> |
| [`FGenTriggerSource`](#fgentriggersource) | <code class="prettyprint lang-MATLAB">'BUS'</code> |
| [`burstCycles`](#burstcycles) | <code class="prettyprint lang-MATLAB">1</code> |
|||

### Pulse Measurement
|Setting | Default Value |
|--------|---------------:|
| [`scopeSampleRate`](#scopesamplerate) | <code class="prettyprint lang-MATLAB">10E9</code> |
| [`scopeRecordLength`](#scoperecordlength) | <code class="prettyprint lang-MATLAB">2000000</code> |
| [`useAutoRecordLength`](#useautorecordlength) | <code class="prettyprint lang-MATLAB">true</code> |
| [`autoRecordLengthBuffer`](#autorecordlengthbuffer) | <code class="prettyprint lang-MATLAB">1.5</code> |
| [`numBytes`](#numbytes) | <code class="prettyprint lang-MATLAB">1</code> |
| [`encoding`](#encoding) | <code class="prettyprint lang-MATLAB">'SRI'</code> |
| [`numVerticalDivisions`](#numverticaldivisions) | <code class="prettyprint lang-MATLAB">10</code> |
| [`chProbeGain`](#chprobegain) | <code class="prettyprint lang-MATLAB">[1, 1, 1, 1]</code> |
| [`invertCurrent`](#invertcurrent) | <code class="prettyprint lang-MATLAB">true</code> |
| [`chInitialOffset`](#chinitialoffset) | <code class="prettyprint lang-MATLAB">[0, 0, 0, 0]</code> |
| [`chInitialScale`](#chinitialscale) | <code class="prettyprint lang-MATLAB">[0, 0, 0, 0]</code> |
| [`chInitialPosition`](#chinitialposition) | <code class="prettyprint lang-MATLAB">[0, 0, 0, 0]</code> |
| [`maxCurrentSpike`](#maxcurrentspike) | <code class="prettyprint lang-MATLAB">100</code> |
| [`percentBuffer`](#percentbuffer) | <code class="prettyprint lang-MATLAB">10</code> |
| [`deskewVoltage`](#deskewvoltage) | <code class="prettyprint lang-MATLAB">min(busVoltages)</code> |
| [`deskewCurrent`](#deskewcurrent) | <code class="prettyprint lang-MATLAB">max(loadCurrents)</code> |
| [`currentDelay`](#currentdelay) | |
| [`VGSDeskew`](#vgsdeskew) | <code class="prettyprint lang-MATLAB">0</code> |
| [`horizontalScale`](#horizontalscale) | <code class="prettyprint lang-MATLAB">50e-6</code> |
| [`delayMode`](#delaymode) | <code class="prettyprint lang-MATLAB">'Off'</code> |
| [`horizontalPosition`](#horizontalposition) | <code class="prettyprint lang-MATLAB">5</code> |
| [`triggerType`](#triggertype) | <code class="prettyprint lang-MATLAB">'EDGe'</code> |
| [`triggerCoupling`](#triggercoupling) | <code class="prettyprint lang-MATLAB">'DC'</code> |
| [`triggerSlope`](#triggerslope) | <code class="prettyprint lang-MATLAB">'FALL'</code> |
| [`triggerSlopeDeskew`](#triggerslopedeskew) | <code class="prettyprint lang-MATLAB">'RISe' </code> |
| [`triggerSource`](#triggersource) | $V_{DS}$ |
| [`triggerSourceDeskew`](#triggersourcedeskew) | $V_{GS}$ |
| [`triggerLevel`](#triggerlevel) | <code class="prettyprint lang-MATLAB">min(busVoltages) / 2</code> |
| [`triggerLevelDeskew`](#triggerleveldeskew) | <code class="prettyprint lang-MATLAB">maxGateVoltage / 2</code> |
| [`acquisitionMode`](#acquisitionmode) | <code class="prettyprint lang-MATLAB">'SAMple'</code> |
| [`acquisitionSamplingMode`](#acquisitionsamplingmode) | <code class="prettyprint lang-MATLAB">'RT'</code> |
| [`acquisitionStop`](#acquisitionstop) | <code class="prettyprint lang-MATLAB">'SEQuence'</code> |
|||

### Data Saving
|Setting | Default Value |
|--------|---------------:|
| [`dataDirectory`](#datadirectory) | <code class="prettyprint lang-MATLAB">'Measurements\' </code> |
|||

### Windows Size
|Setting | Default Value |
|--------|---------------:|
| [`window.turn_on_prequel`](#windowturn_on_prequel) | <code class="prettyprint lang-MATLAB">30e-9</code> |
| [`window.turn_on_time`](#windowturn_on_time) | <code class="prettyprint lang-MATLAB">80e-9</code> |
| [`window.turn_off_prequel`](#windowturn_off_prequel) | <code class="prettyprint lang-MATLAB">30e-9</code> |
| [`window.turn_off_time`](#windowturn_off_time) | <code class="prettyprint lang-MATLAB">80e-9 </code> |
|||

### Automation Level
|Setting | Default Value |
|--------|---------------:|
| [`push2pulse`](#push2pulse) | <code class="prettyprint lang-MATLAB">false</code>
| [`autoBusControl`](#autobuscontrol) | <code class="prettyprint lang-MATLAB">false</code>
| [`busSlewRate`](#busslewrate) | <code class="prettyprint lang-MATLAB">100</code>
|||

## Settings
### Test Specific Settings
#### busVoltages
| Properties | |
|---------|:--|
| Default Value |  |
| Acceptable Values | Any integer or array of integers |
| Units | Volts |
| Description | Must be set by the user for the program to run. Determines the Bus Voltages that will be tested.  |
|||


#### loadCurrents
| Properties | |
|---------|:--|
| Default Value |  |
| Acceptable Values | Any integer or array of integers |
| Units | Amps |
| Description | Must be set by the user for the program to run. Determines the Load Currents that will be tested. |
|||


#### currentResistor
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any float |
| Units | Ohms |
| Description | Must be set by the user for the program to run. Controls the scaling of the drain current channel on the oscilloscope. It should be set to the value of the resistance for the current sensing resistor. |
|||


#### loadInductor
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any float |
| Units | Henrys |
| Description | Must be set by the user for the program to run. Used to calculate the charging time for the various load currents. It is very important that this value is set correctly. Failure to do so will result in an unpredictable amount of current flowing through the test device. It should be set to the value of the load inductor. |
|||


#### minGateVoltage
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">0 </code> |
| Acceptable Values | Any Float, must be less than maxGateVoltage |
| Units | Volts |
| Description | Used to calculate the scaling for the gate voltage channel in the oscilloscope. It should be set to the minimum expected value of the gate driver's output. |
|||


#### maxGateVoltage
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any Float, must be greater than minGateVoltage |
| Units | Volts |
| Description | Used to calculate the scaling for the gate voltage channel in the oscilloscope. It should be set to the maximum expected value of the gate driver's output. |
|||


#### gateLogicVoltage
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any Float |
| Units | Volts |
| Description | Controls the output of the function generator. It should be set to the input voltage of the gate driver. |
|||


#### channel.VDS
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Integer [1-4]|
| Units | |
| Description | Channel that the probe measuring $V_{DS}$ is connected to. |
|||

#### channel.VGS
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Integer [1-4] |
| Units | |
| Description | Channel that the probe measuring $V_{GS}$ is connected to. |
|||

#### channel.ID
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Integer [1-4] |
| Units | |
| Description | Channel that the probe measuring $I_{D}$ is connected to. |
|||

#### channel.IL
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Integer [1-4] |
| Units | |
| Description | Channel that the probe measuring $I_{L}$ is connected to. Should not be set if the load current is not being measured. |
|||


### Instrument Setup
#### FGen_buffer_size
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">6000000 </code> |
| Acceptable Values | Integer less than the maximum buffer size of computer and instrument|
| Units | |
| Description | Controls the buffer size of the Function Generator. Should not be set to large or it will cause the program to fail, small values are taken into account for most data transfers that have the potential to be large. Change only if necessary.  |
|||


#### Scope_Buffer_size
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">200000 </code> |
| Acceptable Values | Integer less than the maximum buffer size of computer and instrument |
| Units | |
| Description | Controls the buffer size of the Oscilloscope. Should not be set to large or it will cause the program to fail, small values are taken into account for most data transfers that have the potential to be large. Change only if necessary.  |
|||


#### Bus_Supply_buffer_size
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">200000 </code> |
| Acceptable Values | Integer less than the maximum buffer size of computer and instrument |
| Units | |
| Description | Controls the buffer size of the blah. Should not be set to large or it will cause the program to fail, small values are taken into account for most data transfers that have the potential to be large. Change only if necessary.  |
|||


#### scopeVisaAddress
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any VISA Address Ex: (<code class="prettyprint lang-MATLAB">'USB0::0x0699::0x0502::C051196::0::INSTR'</code>) |
| Units | |
| Description | VISA Address of the oscilloscope. |
|||


#### FGenVisaAddress
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any VISA Address Ex: (<code class="prettyprint lang-MATLAB">'USB0::0x0699::0x0502::C051196::0::INSTR'</code>) |
| Units | |
| Description | VISA Address of the Function Generator. |
|||


#### BusSupplyVisaAddress
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any VISA Address Ex: (<code class="prettyprint lang-MATLAB">'USB0::0x0699::0x0502::C051196::0::INSTR'</code>) |
| Units | |
| Description | VISA Address of the Bus Voltage Supply. |
|||


#### scopeVendor
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'tek' </code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{'tek' \| 'agilent' \| 'ni'}</code>|
| Units | |
| Description | Vendor for the oscilloscope. Determines which VISA library is used.|
|||


#### FGenVendor
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'agilent' </code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{'tek' \| 'agilent' \| 'ni'}</code>|
| Units | |
| Description |Vendor for the Function Generator. Determines which VISA library is used. |
|||


#### BusSupplyVendor
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'agilent' </code> |
| Acceptable Values |<code class="prettyprint lang-MATLAB">{'tek' \| 'agilent' \| 'ni'}</code> |
| Units | |
| Description |Vendor for the Bus Voltage Supply. Determines which VISA library is used. |
|||


#### scopeTimeout
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">10 </code> |
| Acceptable Values | Any Integer |
| Units | Seconds |
| Description | Time before VISA commands to the oscilloscope will time out. |
|||


#### scopeByteOrder
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'littleEndian' </code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{'littleEndian' \| 'bigEndian'} </code>|
| Units | |
| Description | Sets the byte order for communication with the oscilloscope. |
|||




### Pulse Creation
#### pulse_lead_dead_t
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1e-6</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | The Double Pulse pulse is separated into five segments. The first segment is the initial off, the second segment is the first pulse, the third is the dead period between the two pulses, the fourth is the second pulse, and the fifth and final segment is the final off. This setting controls the time of the first segment, the initial dead time. |
|||


#### pulse_off_t
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">5e-6</code> |
| Acceptable Values | Any Float |
| Units | Seconds  |
| Description | The Double Pulse pulse is separated into five segments. The first segment is the initial off, the second segment is the first pulse, the third is the dead period between the two pulses, the fourth is the second pulse, and the fifth and final segment is the final off. This setting controls the time of the third segment, the dead period between pulses.  |
|||


#### pulse_second_pulse_t
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">5e-6</code> |
| Acceptable Values | Any Float  |
| Units | Seconds  |
| Description | The Double Pulse pulse is separated into five segments. The first segment is the initial off, the second segment is the first pulse, the third is the dead period between the two pulses, the fourth is the second pulse, and the fifth and final segment is the final off. This setting controls the time of the fourth segment, the second pulse.  |
|||


#### pulse_end_dead_t
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1e-6</code> |
| Acceptable Values | Any Float  |
| Units | Seconds  |
| Description | The Double Pulse pulse is separated into five segments. The first segment is the initial off, the second segment is the first pulse, the third is the dead period between the two pulses, the fourth is the second pulse, and the fifth and final segment is the final off. This setting controls the time of the fifth segment, the final off.  |
|||


#### use_mini_2nd_pulse
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">false</code> |
| Acceptable Values | Boolean |
| Units | |
| Description | Switch for turning the four level gate driver on. The four level gate driver uses channel 1 on the function generator in the same way as the two level gate driver; however, channel 2 is always high except for a very short pulse at the beginning of the turn on pulse. |
|||


#### mini_2nd_pulse_off_time
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">50e-9</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | The time that the mini pulse is off. Currently the mini pulse starts 17 ns after the turn on starts. This is hard coded, but can be changed in the future. |
|||


#### burstMode
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'TRIGgered'</code> |
| Acceptable Values | Function Generator Dependent |
| Units | |
| Description | Sets the burst mode for the function generator. Changing this setting is not recommended.  |
|||


#### FGenTriggerSource
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'BUS'</code> |
| Acceptable Values | Function Generator Dependent |
| Units | |
| Description | Sets the trigger source for the Function Generator. The default value allows the computer to trigger the function generator. Changing this setting is not recommended.   |
|||


#### burstCycles
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1</code> |
| Acceptable Values | Function Generator Dependent |
| Units | |
| Description | Sets the number of burst cycles per trigger event. Changing this setting is not recommended. |
|||



### Pulse Measurement
#### scopeSampleRate
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">10E9</code> |
| Acceptable Values | Any Integer (Scope Dependent) |
| Units | Samples / Second|
| Description | Sets the desired Sample Rate of the Oscilloscope. The 5000 series supports an arbitrary number of samples; however, some oscilloscopes will require certain discrete values.|
|||


#### scopeRecordLength
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">2000000</code> |
| Acceptable Values | Any Integer (Scope Dependent)|
| Units | Samples |
| Description | Sets the default number of samples to record for each capture. This setting will be ignored if [useAutoRecordLength](#useautorecordlength)'s value is true (default). |
|||


#### useAutoRecordLength
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">true</code> |
| Acceptable Values | Boolean |
| Units | |
| Description | Sets record length behavior. With a value of <code class="prettyprint lang-MATLAB">true</code> the program will automatically choose the record length. With a value of <code class="prettyprint lang-MATLAB">false</code> the program will use the value of [scopeRecordLength](#scoperecordlength) for the record length.|
|||


#### autoRecordLengthBuffer
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1.5</code> |
| Acceptable Values | Any Float |
| Units | |
| Description | Multiplier for the use with the [useAutoRecordLength](#useautorecordlength) setting. The oscilloscope will capture data for the length of the pulse $\times$ autoRecordLengthBuffer. |
|||


#### numBytes
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1</code> |
| Acceptable Values | 1 |
| Units | |
| Description | Controls the number of bytes used to represent each sample point. Currently only one byte is supported as the oscilloscopes we use can only use 8 bits at their maximum sample rates. Support for high resolution modes with two bytes per sample point is planned, but is not yet implemented. |
|||


#### encoding
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'SRI'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">'SRI'</code> |
| Units | |
| Description | Controls the encoding of the bytes used to transmit data to and from the scope. There are other values that can be used for this variable; however, their behavior is not tested, and changing this value is not recommended. |
|||


#### numVerticalDivisions
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">10</code> |
| Acceptable Values | Any Integer |
| Units | Divisions |
| Description | Designates the number of vertical divisions contained in the oscilloscope. This value is currently controlled by the user, but in the future it may be determined automatically.  |
|||


#### chProbeGain
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">[1, 1, 1, 1]</code> |
| Acceptable Values | Any array of four integer values |
| Units | |
| Description | Sets the gain for each channel's probe. Currently only has an affect on 4000 series scopes, will be updated in the future. Integer values must be positive and may only accept certain values. See your oscilloscopes documentation. Uses the `CH<x>:PRObe:GAIN` command. |
|||


#### invertCurrent
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">true</code> |
| Acceptable Values | Any Boolean |
| Units |  |
| Description | Determines whether or not the current should be inverted. This is often desirable as the measurement conditions require that the drain current be measured as a negative voltage. Affects both the $I_{D}$ and $I_{L}$ channels. On scopes that do not support inverting this may be done by the MATAB script and not by the oscilloscope itself. |
|||


#### chInitialOffset
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">[0, 0, 0, 0]</code> |
| Acceptable Values |Any array of four float values  |
| Units | Base unit of channel (V, A) |
| Description | Sets the initial offset of the oscilloscope channels. This value will apply to all measurements.  |
|||


#### chInitialScale
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">[0, 0, 0, 0]</code> |
| Acceptable Values | Any array of floats |
| Units | Base unit of channel (V, A) / division |
| Description | Sets the initial scale of the oscilloscope channels. This value will apply to only the deskew pulse for the $V_{DS}$ channel. The value for the $V_{GS}$ channel will apply to the initial pulse of all measurements. The value for the current channels will also apply to the deskew pulse and the initial pulse of all measurements, it should be set large enough to display the largest current spike as well as the largest current. It is recommended to set this value with the [calcDefaultScales](#calcdefaultscales) method after the [deskewVoltage](#deskewvoltage), [minGateVoltage](#mingatevoltage), [maxGateVoltage](#maxgatevoltage), [maxCurrentSpike](#maxcurrentspike), and [loadCurrents](#loadcurrents) settings have been set. |
|||


#### chInitialPosition
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">[0, 0, 0, 0]</code> |
| Acceptable Values | Any array of floats |
| Units | Number of divisions above center division |
| Description |Sets the initial position of the oscilloscope channels. This value will apply to only the deskew pulse for the $V_{DS}$ channel. The value for the $V_{GS}$ channel will apply to the initial pulse of all measurements. The value for the current channels will also apply to the deskew pulse and the initial pulse of all measurements, it should be set large enough to display the largest current spike as well as the largest current. It is recommended to set this value with the [calcDefaultScales](#calcdefaultscales) method after the [deskewVoltage](#deskewvoltage), [minGateVoltage](#mingatevoltage), [maxGateVoltage](#maxgatevoltage), [maxCurrentSpike](#maxcurrentspike), and [loadCurrents](#loadcurrents) settings have been set.  |
|||


#### maxCurrentSpike
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">100</code> |
| Acceptable Values | any float |
| Units | Amps |
| Description | Sets the maximum current spike seen during turn on or turn off, used with the [calcDefaultScales](#calcdefaultscales) method. The [calcDefaultScales](#calcdefaultscales) assumes that the current spike is the same in the positive and negative direction. |
|||


#### percentBuffer
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">10</code> |
| Acceptable Values | Any float |
| Units | % |
| Description | Percentage buffer to use with the oscilloscope display. Will add a buffer of percentBuffer / 2 percent to the top and bottom of the signal. The higher this value is the less resolution the waveform will have; however, a high value decreases the chance that the oscilloscope chops the signal. |
|||


#### deskewVoltage
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">min(busVoltages)</code> |
| Acceptable Values | Any float or <code class="prettyprint lang-MATLAB">NaN</code> |
| Units | Volts |
| Description | Sets the voltage used for the deskew pulse. If set to <code class="prettyprint lang-MATLAB">NaN</code> the value is set to the min of [busVoltages](#busvoltages). |
|||


#### deskewCurrent
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">max(loadCurrents)</code> |
| Acceptable Values |Any float or <code class="prettyprint lang-MATLAB">NaN</code>  |
| Units | Amps |
| Description | Sets the current used for the deskew pulse. If set to <code class="prettyprint lang-MATLAB">NaN</code> the value is set to the max of [loadCurrents](#loadcurrents). |
|||


#### currentDelay
| Properties | |
|---------|:--|
| Default Value | |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | Sets the delay in the current signal; however, this setting is overwritten during the program's operation and user values will be ignored.   |
|||


#### VGSDeskew
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">0</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | Sets the delay in the $V_{GS}$ signal. Uses the `CH<x>:DESKew` command with VGSDeskew as the value.  |
|||


#### horizontalScale
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">50e-6</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | todo: figure out what this really does... |
|||


#### delayMode
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'OFF'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{'ON' \| 'OFF'}</code> |
| Units | |
| Description | Sets the delay mode of the oscilloscope. Changing this setting is not recommended.  |
|||


#### horizontalPosition
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">5</code> |
| Acceptable Values | {0-99} |
| Units | % |
| Description | Sets the position of the trigger point of the oscilloscope on the oscilloscope screen in percent from the left. 0% is right at the left side 50% is right in the middle, and 99% is all the way to the right. NOTE: The upper limit of the waveform position is slightly limited by a value that is determined from the record length (upper limit = 100 - 1/record length). |
|||


#### triggerType
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'EDGe'</code> |
| Acceptable Values |  <code class="prettyprint lang-MATLAB">{ 'EDGE' \| 'LOGIc' \| 'PULse' \| 'VIDeo' \| 'I2C' \| 'CAN' \| 'SPI' \| 'COMMunication' \| 'SERIAL' \| 'RS232' }</code>  (Scope Dependent) |
| Units | |
| Description | Sets the trigger type for the oscilloscope. Changing this value is not recommended for the double pulse test. |
|||


#### triggerCoupling
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'DC'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{ 'AC' \| 'DC' \| 'HFRej' \| 'LFRej' \| 'NOISErej' \| 'ATRIGger' }</code> (Scope Dependent) |
| Units | |
| Description | Sets the trigger coupling for the oscilloscope. |
|||


#### triggerSlope
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'FALL'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{ 'RISe' \| 'FALL' }</code> |
| Units | |
| Description | Sets the trigger slope for all measurements. The deskew trigger slope is set in the [triggerSlopeDeskew](#triggerslopedeskew) setting. |
|||


#### triggerSlopeDeskew
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'RISe' </code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{ 'RISe' \| 'FALL' }</code> |
| Units | |
| Description | Sets the trigger slope for the deskew pulse. The trigger slope for all other measurements is set in the [triggerSlope](#triggerslope) setting. |
|||


#### triggerSource
| Properties | |
|---------|:--|
| Default Value | $V_{DS}$ Channel |
| Acceptable Values | {1-4} or <code class="prettyprint lang-MATLAB">NaN</code> |
| Units | |
| Description | Sets the channel that the trigger for all measurements will come from. If set to <code class="prettyprint lang-MATLAB">NaN</code> it will default to the channel that $V_{DS}$ is assigned to. The deskew trigger source is set in the [triggerSourceDeskew](#triggersourcedeskew) setting. |
|||


#### triggerSourceDeskew
| Properties | |
|---------|:--|
| Default Value | $V_{GS}$ Channel |
| Acceptable Values | {1-4} or <code class="prettyprint lang-MATLAB">NaN</code> |
| Units | |
| Description | Sets the channel that the trigger for the deskew will come from. If set to <code class="prettyprint lang-MATLAB">NaN</code> it will default to the channel that $V_{GS}$ is assigned to. The trigger source for all other measurements is set in the [triggerSource](#triggersource) setting. |
|||


#### triggerLevel
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">min(busVoltages) / 2</code>|
| Acceptable Values | Any Float or <code class="prettyprint lang-MATLAB">NaN</code> |
| Units | Volts |
| Description | Sets the trigger level for all measurements except the deskew measurement. If set to <code class="prettyprint lang-MATLAB">NaN</code> it will default to half of the minimum of [busVoltages](#busvoltages). The trigger level for the deskew pulse is set by the [triggerLevelDeskew](#triggerleveldeskew) setting. |
|||


#### triggerLevelDeskew
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">maxGateVoltage / 2</code> |
| Acceptable Values | Any Float or <code class="prettyprint lang-MATLAB">NaN</code> |
| Units | Volts |
| Description | Sets the trigger level for the deskew measurement. If set to <code class="prettyprint lang-MATLAB">NaN</code> it will default to half of [maxGateVoltage](#maxgatevoltage). The trigger level for all other measurements is set by the [triggerLevel](#triggerlevel) setting. |
|||


#### acquisitionMode
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'SAMple'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{ 'SAMple' \| 'HIRes' }</code> (Scope Dependent) |
| Units | |
| Description | Sets the acquisition mode of the oscilloscope. If <code class="prettyprint lang-MATLAB">'HIRes'</code> is used it will likely be desirable to change the number of Bytes send with the [numBytes](#numbytes) setting. |
|||


#### acquisitionSamplingMode
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'RT'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{ 'RT' \| 'ET' \| 'IT' }</code> (Scope Dependent) |
| Units | |
| Description | Sets the sampling mode of the oscilloscope. See oscilloscope user manual for more details. |
|||


#### acquisitionStop
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'SEQuence'</code> |
| Acceptable Values | <code class="prettyprint lang-MATLAB">{ 'RUNSTop' \| 'SEQuence' }</code> |
| Units | |
| Description | Sets the stop after setting of the oscilloscope for all measurements. It is very unlikely that <code class="prettyprint lang-MATLAB">'RUNSTop'</code> will produce desirable results.  |
|||



### Data Saving
#### dataDirectory
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'Measurements\' </code> |
| Acceptable Values | Any Directory |
| Units | |
| Description | Sets the directory that will be used for saving the results of the double pulse test. May be a relative or an absolute path.  |
|||



### Windows Size
#### window.turn_on_prequel
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">30e-9</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | Sets the time to show in plots before the turn on. |
|||

#### window.turn_on_time
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">80e-9</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | Sets the time to show in plots after the turn on. |
|||

#### window.turn_off_prequel
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">30e-9</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | Sets the time to show in plots before the turn off.  |
|||

#### window.turn_off_time
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">80e-9</code> |
| Acceptable Values | Any Float |
| Units | Seconds |
| Description | Sets the time to show in plots after the turn off. |
|||

### Automation Level
#### push2pulse
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">false</code> |
| Acceptable Values | Any Boolean |
| Units | |
| Description | If set to true this setting will cause the program to ask the user to confirm before every pulse. |
|||

#### autoBusControl
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">false</code> |
| Acceptable Values | Any Boolean |
| Units | |
| Description | If set to true this setting will allow the program to automatically control the Bus Supply. If set to false the user will be asked to adjust the voltage by hand. The voltage changes will be slewed with a slew rate set by the [busSlewRate](#busslewrate) setting. |
|||

#### busSlewRate
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">100</code> |
| Acceptable Values | Any Float |
| Units | $\frac{\text{Volts}}{\text{Second}}$ |
| Description | Sets the slew rate for changing the voltage of bus supplies with the program.  |
|||

## Methods
### Constructor
Initializes the object with default values and creates the sub [channelMapper][channelMapper] and [WindowSize][WindowSize] objects.

### calcScale
#### Arguments
(channel, minValue, maxValue, percentBuffer)
#### Description
Calculates the scale for the given channel so that it will show values from minValue to maxValue with a buffer of (percentBuffer / 2)% on the top and bottom.

### calcDefaultScales
Calls the [calcScale](#calcscale) method for all measured values with large buffers. Can only be called after the channel values, [deskewVoltage](#deskewvoltage), [minGateVoltage](#mingatevoltage), [maxGateVoltage](#maxgatevoltage), [maxCurrentSpike](#maxcurrentspike), and [loadCurrents](#loadcurrents) settings have been set. 

## Legacy Code
### Channels
The correct method of accessing the channel number of a particular measurement is with the `obj.channel.<MEAS>` syntax; however, it is also currently still possible to access them in the old method with the `obj.<MEAS>_Channel` syntax. Use of this syntax is deprecated and will likely be removed at some point, so it is recommended not to use it.



[channelMapper]: channelMapper.html
[WindowSize]: WindowSize.html