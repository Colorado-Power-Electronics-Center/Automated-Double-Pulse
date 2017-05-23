# SCPI_Oscilloscope
Use of this class requires knowledge of oscilloscope that is being controlled and it's programming manual. An attempt to use the SCPI_Oscilloscope class without the assistance of your oscilloscope's programming manual is a futile effort. This class is also very incomplete, please add new methods and properties as needed using those already present as a template. 

## Table of Contents
[TOC]

## Super Classes
[SCPI_Instrument][SCPI_Instrument]
handle

## Properties (Constant)
### Series2000
| Properties | |
|---------|:--|
| Default Value | '2XXX' |
| Type | String |
| Units |  |
| Description | String Constant for 2000 Series Tektronix Oscilloscopes. |
|||

### Series4000
| Properties | |
|---------|:--|
| Default Value | '4XXX' |
| Type | String |
| Units |  |
| Description | String Constant for 4000 Series Tektronix Oscilloscopes. |
|||

### Series5000
| Properties | |
|---------|:--|
| Default Value | '5XXX' |
| Type | String |
| Units |  |
| Description | String Constant for 2000 Series Tektronix Oscilloscopes. |
|||

## Properties
### scopeSeries
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | The series of a particular scope object. Set by the [setSeries](#setseries) method. Currently supports Tektronix 2, 4, and 5000 series scopes.|
|||

### Horizontal Command Group
#### recordLengthCommand
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units | String |
| Description | Command that is used for a particular oscilloscope to set or get the record Length. It is set by the [setSeriesStr](#setseriesstr) method. |
|||


#### sampleRateCommand
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units | String |
| Description | Command that is used for a particular oscilloscope to set or get the sample Rate. It is set by the [setSeriesStr](#setseriesstr) method. |
|||


#### horizontalScaleCommand
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units | String |
| Description | Command that is used for a particular oscilloscope to set or get the horizontal Scale. It is set by the [setSeriesStr](#setseriesstr) method. |
|||

## Properties (Dependent)
### Acquisition Command Group

#### acqMode
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | The acquisition mode of the oscilloscope controlled by using the <code class="prettyprint lang-MATLAB">'ACQuire:MODe '</code> command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'SAMple' \| 'PEAKdetect' \| 'HIRes' \| 'AVErage' \| 'ENVelope' }</code>|
|||


#### acqStopAfter
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | The acquisition stop after setting controlled by using the <code class="prettyprint lang-MATLAB">'ACQuire:STOPAfter '</code> command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'RUNSTop' \| 'SEQuence' }</code> |
|||


#### acqState
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | The current acquisition state controlled by using the <code class="prettyprint lang-MATLAB">'ACQuire:STATE '</code> command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'OFF' \| 'ON' \| 'RUN' \| 'STOP' \| (Any Number) }</code> |
|||


#### acqSamplingMode
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | The sampling mode setting controlled by using the <code class="prettyprint lang-MATLAB">'ACQuire:SAMPlingmode '</code> command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'RT' \| 'ET' \| 'IT' }</code> |
|||


### Hard Copy Command

#### exportFilename
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Controls the filename of the next export command. Uses the <code class="prettyprint lang-MATLAB">'EXPort:FILEName'</code> SCPI command.  |
|||


### Horizontal Command Group

#### recordLength
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units |  |
| Description | Controls the oscilloscope's record Length by using the [recordLengthCommand](#recordlengthcommand). |
|||


#### sampleRate
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units | Hertz |
| Description | Controls the oscilloscope's sample Rate by using the [sampleRateCommand](#sampleratecommand). |
|||


#### horizontalScale
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Units per divisions |
| Description | Controls the oscilloscope's horizontal Scale by using the [horizontalScaleCommand](#horizontalscalecommand). |
|||


#### horizontalPosition
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Percentage |
| Description | Controls the oscilloscope's horizontal Position by using the <code class="prettyprint lang-MATLAB">'HORizontal:POSition '</code> command. The argument is the horizontal position expressed as the percentage of the waveform displayed left of the center of the graticule. |
|||


#### horizontalMode
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units |  |
| Description | Controls the oscilloscope's horizontal Mode by using the <code class="prettyprint lang-MATLAB">'HORizontal:MODE '</code> command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'AUTO' \| 'CONStant' \| 'MANual' }</code> |
|||


#### horizontalDelayMode
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units |  |
| Description | Controls the oscilloscope's horizontal Delay Mode by using the <code class="prettyprint lang-MATLAB">'HORizontal:DELay:MODe '</code> command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'OFF' \| 'ON' }</code>|
|||


### Waveform Transfer Command Group

#### dataStart
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Integer |
| Units |  |
| Description | Controls the oscilloscope's data start by using the <code class="prettyprint lang-MATLAB">'DATa:STARt '</code> Command. Sets or returns the starting data point for incoming or outgoing waveform transfer. This command allows for the transfer of partial waveforms to and from the oscilloscope. |
|||


#### dataStop
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units |  |
| Description | Controls the oscilloscope's data stop by using the <code class="prettyprint lang-MATLAB">'DATa:STOP '</code> Command. Sets or returns the last data point that will be transferred when using the CURVe? query. This command allows for the transfer of partial waveforms from the oscilloscope. |
|||


#### dataResolution
| Properties | |
|---------|:--|
| Default Value |  |
| Type |  |
| Units |  |
| Description | Controls the oscilloscope's data resolution by using the <code class="prettyprint lang-MATLAB">'DATa:RESOlution '</code> Command. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'FULL' \| 'REDUced' }</code>  |
|||


## Methods
### Super Overrides
#### Constructor
Constructor is the same as [SCPI_Instrument][SCPI_Instrument].

#### connect
The connect method performs the same actions as [SCPI_Instrument][SCPI_Instrument]; however, it also calls the [setSeries](#setseries) method. 

### Miscellaneous Methods
#### setSeries
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Automatically determines the series of the oscilloscope in order to determine the appropriate command strings for certain oscilloscope dependent commands. Currently supports the 2, 4, and 5000 series oscilloscopes.|
|||

#### setSeriesStr
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Sets series specific command strings. |
|||

### Channel Methods
#### allChannelsOn
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Turns all channels on. |
|||

#### allChannelsOff
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Turns all channels off. |
|||

#### channelsOn
| Method | |
|--------|:--|
| Arguments | (String \| Integer Array) channels |
| Output |  |
| Description | Turns the channels specified by the argument on. |
|||

#### channelsOff
| Method | |
|--------|:--|
| Arguments | (String \| Integer Array) channels |
| Output |  |
| Description | Turns the channels specified by the argument off. |
|||

#### isChannelOn
| Method | |
|--------|:--|
| Arguments | (String \| Integer) channel |
| Output | (Boolean) out |
| Description | Checks if a channel is on and returns true if so, false if not. |
|||

#### getChannelsState
| Method | |
|--------|:--|
| Arguments |  |
| Output | (Boolean Array) channelStates |
| Description | Checks the state of all channels and returns an array of booleans containing true for the channels that are on and false for those that are off.  |
|||

#### enabledChannels
| Method | |
|--------|:--|
| Arguments |  |
| Output | (Integer Array) onChannels |
| Description | Returns an array containing the number of each channel that is on. (e.g. if channels 1 and 3 are on the return will be [1, 3].) |
|||

#### rescaleChannel
| Method | |
|--------|:--|
| Arguments | (Integer) channel, (Float Array) waveform, (Integer) numDivisions, (Float) percentBuffer |
| | channel: Channel to rescale|
| | waveform: Waveform vector containing channel's waveform|
| | numDivisions: Number of divisions on oscilloscope screen|
| | percentBuffer: Integer percent buffer to increase scale by adds percentBuffer / 2 to top and bottom.|
| Output |  |
| Description | rescaleChannel Rescales channel to give full range of values. |
|||

#### minMaxRescaleChannel
| Method | |
|--------|:--|
| Arguments | (Integer channel, (Float) minValue, (Float) maxValue, (Integer) numDivisions, (Float) percentBuffer |
| | channel: Channel to rescale|
| | minValue: Minimum value to be displayed on Oscilloscope|
| | maxValue: Maximum Value to be displayed on Oscilloscope|
| | numDivisions: Number of divisions on oscilloscope screen|
| | percentBuffer: Integer percent buffer to increase scale by adds percentBuffer / 2 to top and bottom.|
| Output |  |
| Description | minMaxRescaleChannel Rescales channel to give full range of values. Based on supplied minimum and maximum values. |
|||

#### setChProbeGain
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Integer) chProbeGain |
| Output |  |
| Description | Sets Channel ProbeGain |
|||

#### getChProbeGain
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chProbeGain |
| Description | Gets current Channel ProbeGain. |
|||


#### setChOffSet
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chOffSet |
| Output |  |
| Description | Sets Channel Offset |
|||

#### getChOffSet
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chOffSet |
| Description | Gets current Channel OffSet. |
|||


#### setChScale
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chScale |
| Output |  |
| Description | Sets Channel Scale |
|||

#### getChScale
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chScale |
| Description | Gets current Channel Scale. |
|||


#### setChPosition
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chPosition |
| Output |  |
| Description | Sets Channel Position |
|||

#### getChPosition
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chPosition |
| Description | Gets current Channel Position. |
|||


#### setChDeskew
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chDeskew |
| Output |  |
| Description | Sets Channel Deskew |
|||

#### getChDeskew
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chDeskew |
| Description | Gets current Channel Deskew. |
|||


#### setChTermination
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chTermination |
| Output |  |
| Description | Sets Channel Termination. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'FIFty' \| 'MEG' \| (Any Number)}</code>|
|||

#### getChTermination
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (String) chTermination |
| Description | Gets current Channel Termination. |
|||

#### getChDegaussState
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (String) chDegauss |
|  | NEEDED: indicates the probe should be degaussed before taking measurements. |
|  | RECOMMENDED: indicates the measurement accuracy might be improved by degaussing the probe. |
|  | PASSED: indicates the probe is degaussed. |
|  | FAILED: indicates the degauss operation failed. |
|  | RUNNING: indicates the probe degauss operation is currently in progress. |
| Description | Returns the state of the probe degauss for the channel specified. |
|||

#### setChInvert
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (String) chInvert |
| Output |  |
| Description | Sets the Channel Invert. Either <code class="prettyprint lang-MATLAB">'ON' or 'OFF'</code>. |
|||

#### getChInvert
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (String) chInvert |
| Description | Sets the Channel Invert. Either <code class="prettyprint lang-MATLAB">'ON' or 'OFF'</code>. |
|||

#### setChProbeForcedRange
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chForcedRange |
| Output |  |
| Description | Sets the range of a TekVPI probe attached to the channel specified. |
|||

#### getChProbeForcedRange
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chForcedRange |
| Description | Returns the range of a TekVPI probe attached to the channel specified. |
|||

#### setChProbeControl
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (String) chProbeControl |
| Output |  |
| Description | Switches probe between auto and manual Mode. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'AUTO' \| 'MANual' }</code> |
|||

#### getChProbeControl
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (String) chProbeControl |
| Description | Returns probe control setting. Possible values are scope dependent, but are most likely <code class="prettyprint lang-MATLAB">{ 'AUTO' \| 'MANual' }</code> |
|||

#### setChLabelName
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (String) chLabel |
| Output |  |
| Description | Sets the channel's label. |
|||

#### getChLabelName
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (String) chLabel |
| Description | Gets the channel's label. |
|||

#### setChExtAtten
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Float) chExtAtten |
| Output |  |
| Description | Sets external attenuation for channel. Only Supported on the 5000 series scopes. Generally used to convert scaled Voltage to Current. |
|||

#### getChExtAtten
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (Float) chExtAtten |
| Description | Gets external attenuation for channel. Only Supported on the 5000 series scopes. Generally used to convert scaled Voltage to Current. |
|||


#### setChExtAttenUnits
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (String) chExtAttenUnits |
| Output |  |
| Description | Sets external attenuation units for channel. Only Supported on the 5000 series scopes. Generally used to convert scaled Voltage to Current. |
|||

#### getChExtAttenUnits
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel |
| Output | (String) chExtAttenUnits |
| Description | Gets external attenuation units for channel. Only Supported on the 5000 series scopes. Generally used to convert scaled Voltage to Current. |
|||


### Measurement Methods
#### setImmediateMeasurementSource
| Method | |
|--------|:--|
| Arguments | (Integer \| String) sourceChan |
| Output | 	 |
| Description | Sets the source of the Immediate measurement to the channel specified by the sourceChan Parameter |
|||

#### setMeasurementState
| Method | |
|--------|:--|
| Arguments | (Integer \| String) measNum, (Integer \| String) measState |
| Output |  |
| Description | Sets the state of the measNum measurement to measState. measState can be either <code class="prettyprint lang-MATLAB">'ON'</code>, <code class="prettyprint lang-MATLAB">'OFF'</code>, or any number. 0 is equivalent to off whereas any other number is equivalent to on.|
|||

#### setImmediateMeasurementType
| Method | |
|--------|:--|
| Arguments | (String) measType |
| | Acceptable values for measType: { 'AMPlitude' \| 'AREa' \|  'BURst' \| 'CARea' \| 'CMEan' \| 'CRMs' \| 'DELay' \| 'DISTDUty' \| ' EXTINCTDB' \| 'EXTINCTPCT' \| 'EXTINCTRATIO' \| 'EYEHeight' \| ' EYEWIdth' \| 'FALL' \| 'FREQuency' \| 'HIGH' \| 'HITs' \| 'LOW' \| ' MAXimum' \| 'MEAN' \| 'MEDian' \| 'MINImum' \| 'NCROss' \| 'NDUty' \| ' NOVershoot' \| 'NWIdth' \| 'PBASe' \| 'PCROss' \| 'PCTCROss' \| 'PDUty' \| ' PEAKHits' \| 'PERIod' \| 'PHAse' \| 'PK2Pk' \| 'PKPKJitter' \| ' PKPKNoise' \| 'POVershoot' \| 'PTOP' \| 'PWIdth' \| 'QFACtor' \| ' RISe' \| 'RMS' \| 'RMSJitter' \| 'RMSNoise' \| 'SIGMA1' \| 'SIGMA2' \| ' SIGMA3' \| 'SIXSigmajit' \| 'SNRatio' \| 'STDdev' \| 'UNDEFINED' \|  'WAVEFORMS}|
| | <code class="prettyprint lang-MATLAB">'AMPlitude'</code> measures the amplitude of the selected waveform. In other words, it measures the high value less the low value measured over the entire waveform or gated region. Amplitude = High - Low |
| | <code class="prettyprint lang-MATLAB">'AREa'</code> measures the voltage over time. The area is over the entire waveform or gated region and is measured in volt-seconds. The area measured above the ground is positive, while the area below ground is negative. |
| | <code class="prettyprint lang-MATLAB">'BURst'</code> measures the duration of a burst. The measurement is made over the entire waveform or gated region. |
| | <code class="prettyprint lang-MATLAB">'CARea'</code> (cycle area) measures the voltage over time. In other words, it measures in volt-seconds, the area over the first cycle in the waveform or the first cycle in the gated region. The area measured above the common reference point is positive, while the area below the common reference point is negative. |
| | <code class="prettyprint lang-MATLAB">'CMEan'</code> (cycle mean) measures the arithmetic mean over the first cycle in the waveform or the first cycle in the gated region. |
| | <code class="prettyprint lang-MATLAB">'CRMs'</code> (cycle rms) measures the true Root Mean Square voltage over the first cycle in the waveform or the first cycle in the gated region. |
| | <code class="prettyprint lang-MATLAB">'DELay'</code> measures the time between the middle reference (default = 50%) amplitude point of the source waveform and the destination waveform. |
| | <code class="prettyprint lang-MATLAB">'DISTDUty'</code> (duty cycle distortion) measures the time between the falling edge and the rising edge of the eye pattern at the mid reference level. It is the peak-to-peak time variation of the first eye crossing measured at the mid-reference as a percent of the eye period. |
| | <code class="prettyprint lang-MATLAB">'EXTINCTDB'</code> measures the extinction ratio of an optical waveform (eye diagram). Extinction Ratio (dB) measures the ratio of the average power levels for the logic High to the logic Low of an optical waveform and expresses the result in dB. This measurement only works for fast acquisition signals or a reference waveform saved in fast acquisition mode. Extinction dB $= 10 × (log_{10} (High / Low)$ |
| | <code class="prettyprint lang-MATLAB">'EXTINCTPCT'</code> measures the extinction ratio of the selected optical waveform. Extinction Ratio (%) measures the ratio of the average power levels for the logic Low (off) to the logic (High) (on) of an optical waveform and expresses the result in percent. This measurement only works for fast acquisition signals or a reference waveform saved in fast acquisition mode. Extinction % = 100.0 × (Low / High) |
| | <code class="prettyprint lang-MATLAB">'EXTINCTRATIO'</code> measures the extinction ratio of the selected optical waveform. Extinction Ratio measures the ratio of the average power levels for the logic High to the logic Low of an optical waveform and expresses the result without units. This measurement only works for fast acquisition signals or a reference waveform saved in fast acquisition mode. Extinction ratios greater than 100 or less than 1 generate errors; low must be greater than or equal to 1 μW. Extinction Ratio = (High / Low) |
| | <code class="prettyprint lang-MATLAB">'EYEHeight'</code> measures the vertical opening of an eye diagram in volts. |
| | <code class="prettyprint lang-MATLAB">'EYEWidth'</code> measures the width of an eye diagram in seconds. |
| | <code class="prettyprint lang-MATLAB">'FALL'</code> measures the time taken for the falling edge of the first pulse in the waveform or gated region to fall from a high reference value (default is 90%) to a low reference value (default is 10%). |
| | <code class="prettyprint lang-MATLAB">'FREQuency'</code> measures the first cycle in the waveform or gated region. Frequency is the reciprocal of the period and is measured in hertz (Hz), where 1 Hz = 1 cycle per second. |
| | <code class="prettyprint lang-MATLAB">'HIGH'</code> measures the High reference (100% level, sometimes called Topline) of a waveform. You can also limit the High measurement (normally taken over the entire waveform record) to a gated region on the waveform. |
| | <code class="prettyprint lang-MATLAB">'HITs'</code> (histogram hits) measures the number of points in or on the histogram box. LOW measures the Low reference (0% level, sometimes called Baseline) of a waveform. |
| | <code class="prettyprint lang-MATLAB">'MAXimum'</code> finds the maximum amplitude. This value is the most positive peak voltage found. It is measured over the entire waveform or gated region. When histogram is selected with the MEASUrement:METHod command, the maximum measurement measures the voltage of the highest nonzero bin in vertical histograms or the time of the right-most bin in horizontal histograms. |
| | <code class="prettyprint lang-MATLAB">'MEAN'</code> amplitude measurement finds the arithmetic mean over the entire waveform or gated region. When histogram is selected with the MEASUrement:METHod command, the mean measurement measures the average of all acquired points within or on the histogram. |
| | <code class="prettyprint lang-MATLAB">'MEDian'</code> (histogram measurement) measures the middle point of the histogram box. Half of all acquired points within or on the histogram box are less than this value and half are greater than this value. |
| | <code class="prettyprint lang-MATLAB">'MINImum'</code> finds the minimum amplitude. This value is typically the most negative peak voltage. It is measured over the entire waveform or gated region. When histogram is selected with the MEASUrement:METHod command, the minimum measurement measures the lowest nonzero bin in vertical histograms or the time of the left-most nonzero bin in the horizontal histograms. |
| | <code class="prettyprint lang-MATLAB">'NCROss'</code> (timing measurement) measures the time from the trigger point to the first falling edge of the waveform or gated region. The distance (time) is measured at the middle reference amplitude point of the signal. |
| | <code class="prettyprint lang-MATLAB">'NDUty'</code> (negative duty cycle) is the ratio of the negative pulse width to the signal period, expressed as a percentage. The duty cycle is measured on the first cycle in the waveform or gated region. Negative Duty Cycle = (Negative Width) / Period × 100% |
| | <code class="prettyprint lang-MATLAB">'NOVershoot'</code> (negative overshoot) finds the negative overshoot value over the entire waveform or gated region. Negative Overshoot = (Low - Minimum) / Amplitude × 100%) |
| | <code class="prettyprint lang-MATLAB">'NWIdth'</code> (negative width) measurement is the distance (time) between the middle reference (default = 50%) amplitude points of a negative pulse. The measurement is made on the first pulse in the waveform or gated region. |
| | <code class="prettyprint lang-MATLAB">'PBASe'</code> measures the base value used in extinction ratio measurements. |
| | <code class="prettyprint lang-MATLAB">'PCROss'</code> (timing measurement) measures the time from the trigger point to the first positive edge of the waveform or gated region. The distance (time) is measured at the middle reference amplitude point of the signal. |
| | <code class="prettyprint lang-MATLAB">'PCTCROss'</code> measures the location of the eye crossing point expressed as a percentage of EYEHeight. Crossing percent $= 100 \times \left[\frac{\text{eye-crossing-point} - PBASe}{PTOP - PBASe}\right] $|
| | <code class="prettyprint lang-MATLAB">'PDUty'</code> (positive duty cycle) is the ratio of the positive pulse width to the signal period, expressed as a percentage. It is measured on the first cycle in the waveform or gated region. Positive Duty Cycle = (Positive Width)/Period × 100% |
| | <code class="prettyprint lang-MATLAB">'PEAKHits'</code> measures the number of points in the largest bin of the histogram. |
| | <code class="prettyprint lang-MATLAB">'PERIod'</code> is the time required to complete the first cycle in a waveform or gated region. Period is the reciprocal of frequency and is measured in seconds. |
| | <code class="prettyprint lang-MATLAB">'PHAse'</code> measures the phase difference (amount of time a waveform leads or lags the reference waveform) between two waveforms. The measurement is made between the middle reference points of the two waveforms and is expressed in degrees, where 360° represents one waveform cycle. |
| | <code class="prettyprint lang-MATLAB">'PK2Pk'</code> (peak-to-peak) finds the absolute difference between the maximum and minimum amplitude in the entire waveform or gated region. When histogram is selected with the MEASUrement:METHod command, the PK2Pk measurement measures the histogram peak to peak difference. |
| | <code class="prettyprint lang-MATLAB">'PKPKJitter'</code> measures the variance (minimum and maximum values) in the time locations of the cross point. |
| | <code class="prettyprint lang-MATLAB">'PKPKNoise'</code> measures the peak-to-peak noise on a waveform at the mid reference level. |
| | <code class="prettyprint lang-MATLAB">'POVershoot'</code> The positive overshoot amplitude measurement finds the positive overshoot value over the entire waveform or gated region. Positive Overshoot = (Maximum - High) / Amplitude ×100% |
| | <code class="prettyprint lang-MATLAB">'PTOT'</code> measures the top value used in extinction ratio measurements. |
| | <code class="prettyprint lang-MATLAB">'PWIdth'</code> (positive width) is the distance (time) between the middle reference (default = 50%) amplitude points of a positive pulse. The measurement is made on the first pulse in the waveform or gated region. |
| | <code class="prettyprint lang-MATLAB">'QFACtor'</code> measures the quality factor. The Q factor is a figure of merit for an eye diagram, which indicates the vertical eye opening relative to the noise at the low and high logic levels. It is the ratio of the eye size to noise. |
| | <code class="prettyprint lang-MATLAB">'RISe'</code> timing measurement finds the rise time of the waveform. The rise time is the time it takes for the leading edge of the first pulse encountered to rise from a low reference value (default is 10%) to a high reference value (default is 90%). RMS amplitude measurement finds the true Root Mean Square voltage in the entire waveform or gated region. |
| | <code class="prettyprint lang-MATLAB">'RMSJitter'</code> measures the variance in the time locations of the cross point. The RMS jitter is defined as one standard deviation at the cross point. |
| | <code class="prettyprint lang-MATLAB">'RMSNoise'</code> measures the Root Mean Square noise amplitude on a waveform at the mid reference level. |
| | <code class="prettyprint lang-MATLAB">'SIGMA1'</code> (histogram measurement) measures the percentage of points in the histogram that are within one standard deviation of the histogram mean. |
| | <code class="prettyprint lang-MATLAB">'SIGMA2'</code> (histogram measurement) measures the percentage of points in the histogram that are within two standard deviations of the histogram mean. |
| | <code class="prettyprint lang-MATLAB">'SIGMA3'</code> (histogram measurement) measures the percentage of points in the histogram that are within three standard deviations of the histogram mean. |
| | <code class="prettyprint lang-MATLAB">'SIXSigmajit'</code> (histogram measurement) is six × RMSJitter. |
| | <code class="prettyprint lang-MATLAB">'SNRatio'</code> measures the signal-to-noise ratio. The signal-to-noise ratio is the amplitude of a noise rejection band centered on the mid level. |
| | <code class="prettyprint lang-MATLAB">'STDdev'</code> measures the standard deviation (Root Mean Square (RMS) deviation) of all acquired points within or on the histogram box. |
| | <code class="prettyprint lang-MATLAB">'UNDEFINED'</code> is the default measurement type, which indicates that no measurement type is specified. Once a measurement type is chosen, it can be cleared using this argument. |
| | <code class="prettyprint lang-MATLAB">'WAVEFORMS'</code> (waveform count) measures the number of waveforms used to calculate the histogram. |
| Output |  |
| Description | This command sets or queries the immediate measurement type. Immediate measurements and annotations are not displayed on the screen. |
|||

#### getImmediateMeasurementValue
| Method | |
|--------|:--|
| Arguments |  |
| Output | (Float) value |
| Description | Gets the value of the immediate measurement. |
|||



### Setup Methods
#### setupTrigger
| Method | |
|--------|:--|
| Arguments | (String) triggerType, (String) coupling, (String) slope, (Integer) source, (Float) level  |
| |triggerType: trigger type <code class="prettyprint lang-MATLAB">{ 'EDGe' \| 'LOGic' \| 'PULSe' \| 'BUS' \| 'VIDeo' }</code>|
| |coupling: Trigger Coupling <code class="prettyprint lang-MATLAB">{ 'DC' \| 'HFRej' \| 'LFRej' \| 'NOISErej' }</code>|
| |slope: Trigger Slope <code class="prettyprint lang-MATLAB">{ 'RISe' \| 'FALL' }</code>|
| |source: Trigger Source (int) <code class="prettyprint lang-MATLAB">{1-4}</code>|
| |level: Trigger Level (double)|
| Output |  |
| Description | setupTrigger sets up oscilloscope trigger currently only works with edge trigger |
|||

#### setupWaveformTransfer
| Method | |
|--------|:--|
| Arguments | (Integer) numBytes, (String) encoding |
| | numBytes: Number of bytes to use to send waveform points. Must be 1 or 2.|
| | encoding: Encoding scheme to use with binary data, see programming manual for acceptable values and descriptions.|
| Output |  |
| Description | setupWaveformTransfer sets binary format for waveform.  |
|||

### Waveform Methods
#### getWaveform
| Method | |
|--------|:--|
| Arguments | (Integer) Channel |
| Output | (Float Array) waveform |
| Description | getWaveform gets one channel's waveform from scope [setupWaveformTransfer](#setupwaveformtransfer) should be called first. |
|||

### Miscellaneous Methods
#### removeHeaders
| Method | |
|--------|:--|
| Arguments |  |
| Output |  |
| Description | Removes headers from the oscilloscope return values. |
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