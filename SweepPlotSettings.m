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
        
        legendSuffix = 'V';
        legendLocation = 'NorthWest';
        
        markerOrder = {'+','o','*','.','x','s','d','^','v','>','<','p','h'}.';
        
        plotMap@containers.Map;
        
    end
end