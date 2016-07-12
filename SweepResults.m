classdef SweepResults < matlab.mixin.Copyable
    %SweepResults Store results of a sweep of double pulse tests
    %   Detailed explanation goes here
    
    properties
        % Raw Results
        chan4Results@DoublePulseResults vector
        chan2Results@DoublePulseResults vector
        
        % Results sorted by voltage
        chan4ByVoltage@containers.Map
        chan2ByVoltage@containers.Map
        
        
    end
    
    properties (Access = private)
        % Used for storing intermediate voltage values
        plotIntResults@DoublePulseResults vector
    end
    
    methods
        function self = SweepResults
            %
            self.chan4ByVoltage = containers.Map('KeyType','int32','ValueType','any');
            self.chan2ByVoltage = containers.Map('KeyType','int32','ValueType','any');
        end
        function addResult(self, numChannels, busVoltage, result)
            %
            if numChannels == 2
                if isKey(self.chan2ByVoltage, busVoltage)
                    curValues = self.chan2ByVoltage(busVoltage);
                else
                    curValues = [];
                end
                self.chan2ByVoltage(busVoltage) = [curValues, result];
            else
                if isKey(self.chan4ByVoltage, busVoltage)
                    curValues = self.chan4ByVoltage(busVoltage);
                else
                    curValues = [];
                end
                self.chan4ByVoltage(busVoltage) = [curValues, result];
            end
        end
        function plotSweep(self, plotSettings)
            % Function to create plot for the turn on Energy Loss with 2
            % Channel Waveforms
            plotFigure = figure;
            plotFigure.Name = plotSettings.title;
            plotFigure.NumberTitle = plotSettings.numberTitle;
            
            % Set Axis Labels
            xlabel(plotSettings.xLabel);
            ylabel(plotSettings.yLabel);
            
            % Setup Legend
            legendStrs = {};
            
            % Setup Marker Order
            markers = plotSettings.markerOrder;
            
            hold on;
            
            for plotLine = plotSettings.plotMap.keys
                % For Every Voltage stored in Map
                self.plotIntResults =  plotSettings.plotMap(plotLine{1});
                xValues = [self.plotIntResults.(plotSettings.xValueName)] * plotSettings.xScale;
                yValues = [self.plotIntResults.(plotSettings.yValueName)] * plotSettings.yScale;
                plotObj = plot(xValues, yValues);
                plotObj.Marker = markers{1};
                markers = circshift(markers, [-1, 0]);
                legendStrs{end+1} = [num2str(plotLine{1}) ' ' plotSettings.legendSuffix];
            end
            
            hold off;
            
            plotLegend = legend(legendStrs);
            plotLegend.Location = plotSettings.legendLocation;
        end
        function plotEOn(self)
            plotSettings = SweepPlotSettings;
            plotSettings.title = 'Turn On Energy Loss';
            plotSettings.xLabel = 'Load Current (A)';
            plotSettings.xValueName = 'loadCurrent';
            plotSettings.yLabel = 'E_{ON} (\muJ)';
            plotSettings.yValueName = 'turnOnEnergy';
            plotSettings.yScale = 1e6;
            
            plotSettings.plotMap = self.chan2ByVoltage;
        end
        function plotEOff(self)
            plotSettings = SweepPlotSettings;
            plotSettings.title = 'Turn Off Energy Loss';
            plotSettings.xLabel = 'Load Current (A)';
            plotSettings.xValueName = 'loadCurrent';
            plotSettings.yLabel = 'E_{ON} (\muJ)';
            plotSettings.yValueName = 'turnOffEnergy';
            plotSettings.yScale = 1e6;
            
            plotSettings.plotMap = self.chan2ByVoltage;
        end
    end
    
end


