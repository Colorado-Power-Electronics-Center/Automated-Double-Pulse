# pulse_generator
The pulse_generator function generates an array of points from a list of times that can be given to a function generator to output an arbitrary pulse waveform.

## Table of Contents
[TOC]

## Methods
### pulse_generator
| Method | |
|--------|:--|
| Arguments | (Float) sampleRate, (Float or Float Array) times, Optional (Unlimited): (Float) times  |
| Output | (Integer Array) pulse_waveform, (Float) total_time |
| Description | Function takes in a sample rate and a list of times in order to create an arbitrary pulse train. The function has two ways of supply the times of the pulse train. The first is to supply an array of all times (e.g. [1, 2, 1, 2, 4]) as the 2nd argument. The second is to supply an unlimited number of arguments to supply the times (e.g. pulse_generator(sampleRate, 1, 2, 1, 2, 4)). In either case the times should be given in seconds and the first number in the list is the initial dead time (meaning in our previous example a pulse will be generated with 1 second off, 2 seconds on, 1 off, 2 on, 4 off). An argument of 0 may be given at any time to put to skip a particular on or off period.  |
|||
