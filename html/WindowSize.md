# WindowSize

## Table of Contents
[TOC]

## Super Classes
matlab.mixin.copyable

## Properties
### turn_on_prequel
| Properties | |
|---------|:--|
| Default Value | 30ns |
| Type | Float |
| Units | Seconds |
| Description | Time to include in the turn on switching waveform before the switch.  |
|||

### turn_on_time
| Properties | |
|---------|:--|
| Default Value | 80ns |
| Type | Float |
| Units | Seconds |
| Description | Time to include in the turn on switching waveform after the switch. |
|||

### turn_off_prequel
| Properties | |
|---------|:--|
| Default Value | 30ns |
| Type | Float |
| Units | Seconds |
| Description | Time to include in the turn off switching waveform before the switch. |
|||

### turn_off_time
| Properties | |
|---------|:--|
| Default Value | 80ns |
| Type | Float |
| Units | Seconds |
| Description | Time to include in the turn off switching waveform after the switch. |
|||

### sampleRate
| Properties | |
|---------|:--|
| Default Value |  |
| Type | Float |
| Units | Hertz |
| Description | Sample rate of the waveform in Hertz. |
|||

## Properties (Dependent)
### turn_on_prequel_idxs
| Properties | |
|---------|:--|
| Default Value | 30ns |
| Type | Float |
| Units | Seconds |
| Description | Indices to include in the turn on switching waveform before the switch. Calculated by multiplying the sample rate and the respective time.  |
|||

### turn_on_time_idxs
| Properties | |
|---------|:--|
| Default Value | 80ns |
| Type | Float |
| Units | Seconds |
| Description | Indices to include in the turn on switching waveform after the switch. Calculated by multiplying the sample rate and the respective time. |
|||

### turn_off_prequel_idxs
| Properties | |
|---------|:--|
| Default Value | 30ns |
| Type | Float |
| Units | Seconds |
| Description | Indices to include in the turn off switching waveform before the switch. Calculated by multiplying the sample rate and the respective time. |
|||

### turn_off_time_idxs
| Properties | |
|---------|:--|
| Default Value | 80ns |
| Type | Float |
| Units | Seconds |
| Description | Indices to include in the turn off switching waveform after the switch. Calculated by multiplying the sample rate and the respective time. |
|||