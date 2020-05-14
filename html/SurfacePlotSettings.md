# SurfacePlotSettings
Adds additional functionality to the [SweepPlotSettings][SweepPlotSettings] class for the purpose of making surfaces.

## Table of Contents
[TOC]

## Super Classes
[SweepPlotSettings][SweepPlotSettings]

## Properties
### xSamples
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">100:5:400</code> |
| Type | (Float) Array |
| Units | Depends on current x value |
| Description | Sets the interpolation grid for the surface plot. In order to create a surface it is necessary to interpolate between the known data points. This is done with a grid of x and y points defined by the [xSamples](#xsamples) and [ySamples](#ysamples) properties. For the default of this property the x values of the grid will start at 100, end at 400, and be spaced 5 units apart. A finer grid will result in a more smooth appearance but will require more computing power and more memory. |
|||

### ySamples
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">3:.5:30</code> |
| Type | (Float) Array |
| Units | Depends on current y value |
| Description | Sets the interpolation grid for the surface plot. In order to create a surface it is necessary to interpolate between the known data points. This is done with a grid of x and y points defined by the [xSamples](#xsamples) and [ySamples](#ysamples) properties. For the default of this property the y values of the grid will start at 3, end at 30, and be spaced 0.5 units apart. A finer grid will result in a more smooth appearance but will require more computing power and more memory.  |
|||
