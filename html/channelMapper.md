# channelMapper
## Table of Contents
[TOC]

## Description
The channelMapper class contains the mapping of measurement to oscilloscope channel. 

## Properties
### VDS
| Properties | |
|---------|:--|
| Default Value | `GeneralWaveform.NOT_RECORDED` |
| Acceptable Values | Integer [1-4]|
| Units | |
| Description | Channel that the probe measuring $V_{DS}$ is connected to. |
|||

### VGS
| Properties | |
|---------|:--|
| Default Value | `GeneralWaveform.NOT_RECORDED` |
| Acceptable Values | Integer [1-4] |
| Units | |
| Description | Channel that the probe measuring $V_{GS}$ is connected to. |
|||

### ID
| Properties | |
|---------|:--|
| Default Value | `GeneralWaveform.NOT_RECORDED` |
| Acceptable Values | Integer [1-4] |
| Units | |
| Description | Channel that the probe measuring $I_{D}$ is connected to. |
|||

### IL
| Properties | |
|---------|:--|
| Default Value | `GeneralWaveform.NOT_RECORDED` |
| Acceptable Values | Integer [1-4] |
| Units | |
| Description | Channel that the probe measuring $I_{L}$ is connected to. Should not be set if the load current is not being measured. |
|||

## Methods
### Constructor
| Method | |
|--------|:--|
| Arguments | (VDS_Channel, VGS_Channel, ID_Channel, IL_Channel) |
| Output | channelMapper |
| Description | Creates a new channelMapper object with the channels as given. If no arguments are given all channels default to the value of `GeneralWaveform.NOT_RECORDED`. |
|||

### allUnset
| Method | |
|--------|:--|
| Arguments |  |
| Output | Boolean |
| Description | Returns <code class="prettyprint lang-MATLAB">true</code> if all channels are set to `GeneralWaveform.NOT_RECORDED` otherwise returns <code class="prettyprint lang-MATLAB">false</code>. |
|||