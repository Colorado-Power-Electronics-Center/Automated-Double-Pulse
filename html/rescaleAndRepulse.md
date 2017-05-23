# rescaleAndRepulse
The rescaleAndRepulse function rescales the oscilloscope to take better advantage of the 8-bit ADC. It does not use the waveforms that are currently on the oscilloscope, but rather a set that is passed from the calling function. It assumes that the [runDoublePulseTest][runDoublePulseTest] has already been called.

## Table of Contents
[TOC]

## rescaleAndRepulse
| Method | |
|--------|:--|
| Arguments | ([SCPI_Oscilloscope][SCPI_Oscilloscope]) myScope, ([SCPI_FunctionGenerator][SCPI_FunctionGenerator]) myFGen, (Integer) numChannels, ([FullWaveform][FullWaveform]) scalingWaveforms, ([DPTSettings][DPTSettings]) settings |
| Output | ([FullWaveform][FullWaveform]) returnWaveforms |
| Description | Rescales the oscilloscope to maximize all waveforms and reruns a single operating point of the Double Pulse Test. Returns a [FullWaveform][FullWaveform] object.  |
|||
