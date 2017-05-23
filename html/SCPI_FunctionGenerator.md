# SCPI_FunctionGenerator
SCPI_FunctionGenerator Sub-Class of SCPI_Instrument for use with Function Generators. Currently the class works with Keysight / Agilent Function generators, but it can be modified to work with other scopes either by modifying the methods here or by creating another level of subclass (either beneath this class or SCPI_Instrument) that works with other brands of function generators. 

## Table of Contents
[TOC]

## Super Classes
[SCPI_Instrument][SCPI_Instrument]   
handle

## Methods
### constructor
| Method | |
|--------|:--|
| Arguments | (String) visaVendor, (String) visaAddress |
| Output | [SCPI_FunctionGenerator][SCPI_FunctionGenerator] |
| Description | Identical to parent class. |
|||

### loadArbWaveform
| Method | |
|--------|:--|
| Arguments | (Float Array) wave_points, (Float) sample_rate, (Float) PeakValue, (String) name, (Integer \| String) channel |
| | wave_points: Vector of datapoints in the wave |
| | sample_rate: Rate at which data points should be read |
| | PeakValue: Maximum height of waveform (bottom is always 0) |
| | name: String title of waveform (max 12 Characters) |
| | channel: Function Generator Channel to load waveform on, can be string or number. |
| Output |  |
| Description | loads arbitrary waveform onto Function |
|||

### setupBurst
| Method | |
|--------|:--|
| Arguments | (String) mode, (Integer) nCycles, (Float) period, (String) source, (Integer \| String) channel |
| | mode: Burst mode  <code class="prettyprint lang-MATLAB">{ 'TRIGgered' \| 'GATed' }</code>|
| | nCycles: Number of times to send burst |
| | period: Total length of each cycle |
| | source: Source of burst Trigger  <code class="prettyprint lang-MATLAB">{ 'IMMediate' \| 'EXTernal' \| 'TIMer' \| 'BUS' }</code>|
| | channel: Function Generator channel to setup Burst for |
| Output |  |
| Description | Sets Function Generator Burst Settings |
|||

### setOutputLoad
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Integer \| String) load |
| Output |  |
| Description | Set function generator output load for a given channel. Acceptable values for load: <code class="prettyprint lang-MATLAB">{[ohms] \| 'INFinity' \| 'MINimum' \| 'MAXimum' \| 'DEFault' }</code> |
|||

### getOutputLoad
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (String) modifier |
| Output | (Number) load |
| Description | Gets the current output load for the function generator. Can also fetch the maximum and minimum possible values with the modifier parameter. Acceptable values for modifier <code class="prettyprint lang-MATLAB">{ 'MINimum' \| 'MAXimum' }</code>. The modifier parameter is optional. |
|||

### setArbSampleRate
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (Integer \| String) rate |
| Output |  |
| Description | Sets the sample rate for a given channels arbitrary function. Acceptable values for rate are: <code class="prettyprint lang-MATLAB">{[sample_rate] \| 'MINimum' \| 'MAXimum' \| 'DEFault' }</code> |
|||

### getArbSampleRate
| Method | |
|--------|:--|
| Arguments | (Integer \| String) channel, (String) modifier |
| Output | (Number) load |
| Description | Gets the function Generator's arbitrary function sample rate. Can also fetch the maximum and minimum possible values with the modifier parameter. Acceptable values for modifier <code class="prettyprint lang-MATLAB">{ 'MINimum' \| 'MAXimum' }</code>. The modifier parameter is optional. |
|||

### getError
| Method | |
|--------|:--|
| Arguments |  |
| Output | (String) error |
| Description | Gets the most recent error string from the function generator. If there are multiple errors on the error queue this method maybe called multiple times to fetch them all. |
|||







