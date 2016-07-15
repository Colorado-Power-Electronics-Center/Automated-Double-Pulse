classdef SweepPlotSettings
    %
    properties
        title
        numberTitle = 'off';
        xLabel
        xValueName
        xScale = 1;
        yLabel
        yValueName
        yScale = 1;
        zLabel
        zValueName
        zScale = 1;
        
        legendSuffix = 'V';
        legendLocation = 'NorthWest';
        
        markerOrder = {'*','x','s','d','^','v','>','<','p','h'}.';
        
        plotMap@containers.Map;
        
    end
end