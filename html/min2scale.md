# min2Scale
min2Scale calculates the scale and and position required to fit a waveform on an oscilloscope to make full use of the oscilloscope's 8-bot ADC. 

## Table of Contents
[TOC]

## Methods
| Method | |
|--------|:--|
| Arguments | (Float) minValue, (Float) maxValue, (Integer) numDivisions, (Float) percentBuffer |
| Output | [(Float) scale, (Float) position] |
| Description | Determines the scale (Units per division) and the 0 position necessary to maximize the waveforms usage of the Oscilloscope's ADC. minValue is the minimum expected value of the waveform, maxValue is the maximum expected value of the waveform, numDivisions is the number of divisions on the oscilloscope, and percentBuffer is the amount off buffer that should be left on the top and bottom of the waveform. The percent buffer is shared between the top and bottom (i.e. A percent Buffer of 10% (percentBuffer = 10) will result in 5% of the oscilloscope screen being blank at the top and bottom of the waveform. |
|||
