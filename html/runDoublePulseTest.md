# runDoublePulseTest
Runs a single iteration of the Double Pulse test. Before running this function the bus should already be at the appropriate voltage.

## Table of Contents
[TOC]

## runDoublePulseTest
| Method | |
|--------|:--|
| Arguments | ([SCPI_Oscilloscope][SCPI_Oscilloscope]) myScope, ([SCPI_FunctionGenerator][SCPI_FunctionGenerator]) myFGen, (Float) loadCurrent, (Float) busVoltage, ([DPTSettings][DPTSettings]) settings |
| Output | ([FullWaveform][FullWaveform]) returnWaveforms |
| Description | Runs a single operating point of the double pulse test. Sets up oscilloscope and function generator, triggers the function generator, ensures that a waveform was captured, and creates the [FullWaveform][FullWaveform] object to be returned. |
|||
