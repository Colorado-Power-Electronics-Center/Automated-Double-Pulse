# SweepPlotSettings

## Table of Contents
[TOC]

## Properties
### title
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Sets the title for the plot. |
|||

### numberTitle
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'off'</code> |
| Type | String |
| Units |  |
| Description | Set to <code class="prettyprint lang-MATLAB">'on'</code> if you would like the figure titles to be numbered. |
|||


### xLabel
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Sets the x-label |
|||

### xValueName
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Sets the x vale to be used in the plot. Possible values are any property of [DoublePulseResults][DoublePulseResults]. |
|||

### xScale
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1</code> |
| Type | Float |
| Units |  |
| Description | Sets the scale for the x values. Can be used to normalize data. |
|||


### yLabel
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Sets the y-label for the plot. |
|||


### yValueName
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description |  Sets the y vale to be used in the plot. Possible values are any property of [DoublePulseResults][DoublePulseResults] |
|||

### yScale
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1</code> |
| Type | Float |
| Units |  |
| Description | Sets the scale for the y values. Can be used to normalize the data. |
|||


### zLabel
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description | Sets the z-label for the plot. |
|||


### zValueName
| Properties | |
|---------|:--|
| Default Value |  |
| Type | String |
| Units |  |
| Description |  Sets the z vale to be used in the plot. Possible values are any property of [DoublePulseResults][DoublePulseResults] |
|||


### zScale
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">1</code> |
| Type |  |
| Units |  |
| Description | Sets the scale for the z values. Can be used to normalize the data. |
|||


### legendSuffix
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'V'</code> |
| Type | String |
| Units |  |
| Description | Sets the suffix for the legend. |
|||


### legendLocation
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">'NorthWest'</code> |
| Type | String |
| Units |  |
| Description | Sets the location of the legend. |
|||


### markerOrder
| Properties | |
|---------|:--|
| Default Value | <code class="prettyprint lang-MATLAB">{'*','x','s','d','^','v','>','<','p','h'}</code> |
| Type | (String) Cell Array |
| Units |  |
| Description | Sets the marker order for the plot. |
|||


### plotMap
| Properties | |
|---------|:--|
| Default Value |  |
| Type | containers.Map |
| Units |  |
| Description | Sets the data map to use for the plot. Most likely either [chan2ByVoltage](SweepResults.html#chan2byvoltage) or [chan4ByVoltage](SweepResults.html#chan4byvoltage). |
|||


