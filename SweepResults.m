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
        
        % Current Delay
        currentDelay
    end
    
    properties (Access = private)
        % Used for storing intermediate voltage values
        plotIntResults@DoublePulseResults vector
    end
    methods(Access = protected)
       % Override copyElement method:
      function cpObj = copyElement(self)
         % Make a shallow copy of all properties
         cpObj = copyElement@matlab.mixin.Copyable(self);
         
         % Reset Map objects
         cpObj.chan4ByVoltage = containers.Map('KeyType','int32','ValueType','any');
         cpObj.chan2ByVoltage = containers.Map('KeyType','int32','ValueType','any');
         
         % Make a deep copy of the chan4 and chan2ByVoltage Map objects
         for key = self.chan2ByVoltage.keys
            % Copy 2 Channel Measurements
            tempDPR = copy(self.chan2ByVoltage(key{1}));
            cpObj.chan2ByVoltage(key{1}) = tempDPR;

            % Copy 4 Channel Measurements
            tempDPR = copy(self.chan4ByVoltage(key{1}));
            cpObj.chan4ByVoltage(key{1}) = tempDPR;
         end  
      end
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
        function runAllPlots(self, imageType, saveDirectory)
            % Run all methods that contain 'plot' and have one argument
            % Set Image Type to false to not save images.
            methodStrs = methods(self);
            plotMethods = strfind(methodStrs, 'plot');
            plotMethodIdxs = not(cellfun('isempty', plotMethods));
            plotMethodStrs = methodStrs(plotMethodIdxs);
            
            classStr = class(self);
            
            for method = plotMethodStrs.'
                % Check if function has only one argument (self)
                checkStr = [classStr '>' classStr '.' method{1}];
                if nargin(checkStr) == 1
                    if nargin > 1
                        [surfFigure] = self.(method{1})();
                        if imageType
                            data = surfFigure.UserData;

                            % Set Save Directory
                            if nargin > 2
                                saveDir = saveDirectory;
                            else
                                saveDir = ['plotImages/' imageType '/'];
                            end

                            % SaveLoc is directory + filename
                            saveLoc = [saveDir data.friendlyName];

                            % Make directory if it does not exist
                            if ~exist(saveDir, 'dir')
                                mkdir(saveDir);
                            end

                            % Set renderer to painters for vector output
                            surfFigure.Color = 'w';
                            export_fig(surfFigure, saveLoc,...
                                ['-' imageType], '-painters');
                        end
                    else
                        self.(method{1})();
                    end
                end
            end
        end
        function reCalcResults(self)
            % Re run the calculation function for all results
            for key = self.chan2ByVoltage.keys
                %
                tempDPR = self.chan2ByVoltage(key{1});
                tempDPR.calcAllValues;
                self.chan2ByVoltage(key{1}) = tempDPR;
            end  
            for key = self.chan4ByVoltage.keys
                %
                tempDPR = self.chan4ByVoltage(key{1});
                tempDPR.calcAllValues;
                self.chan2ByVoltage(key{1}) = tempDPR;
            end  
        end
        %% shiftAllCurrents: Shift all currents by nanoSec ns.
        function shiftAllCurrents(self, nanoSec)
            % Calculate actual change in delay for 4 channel waveform
            % Grab all Keys from channel 4 measurements
            chan4_1_keys = self.chan4ByVoltage.keys;
            
            % Grab DoublePulseResults of first key
            chan4_1 = self.chan4ByVoltage(chan4_1_keys{1});
            
            % Find sample rate from first DPR in 1st keyed result
            chan4_SR = chan4_1(1).turnOffWaveform.sampleRate;
            
            % Calculate number of Idxs to shift 4 channel
            numIdx = round(abs(nanoSec * 1E-9) * chan4_SR);
            
            % Calculate new number of nanoseconds to shift and update the
            % value
            newNanoSec = numIdx * chan4_SR;
            nanoSec = newNanoSec / 1e-9;            
            
            % Re run the calculation function for all results
            for key = self.chan2ByVoltage.keys
                %
                tempDPR = self.chan2ByVoltage(key{1});
                tempDPR.shiftCurrent(nanoSec);
                self.chan2ByVoltage(key{1}) = tempDPR;
            end  
            for key = self.chan4ByVoltage.keys
                %
                tempDPR = self.chan4ByVoltage(key{1});
                tempDPR.shiftCurrent(nanoSec);
                self.chan2ByVoltage(key{1}) = tempDPR;
            end
            
            % Ensure Values are calculated
            self.reCalcResults;

            self.currentDelay = self.currentDelay + nanoSec * 1e-9;
            
            self.plotEOn
            a = gca;
            if nanoSec >= 0, opStr = '+'; else opStr = ''; end
            title([a.Title.String ' ' opStr ' ' num2str(nanoSec) ' ns']);
        end
        function [plotFigure] = plotSweep(self, plotSettings)
            % Function to create plot for the turn on Energy Loss with 2
            % Channel Waveforms
            plotFigure = figure;
            plotFigure.Name = plotSettings.title;
            title(plotSettings.title);
            plotFigure.NumberTitle = plotSettings.numberTitle;
            curAxis = gca;
            curAxis.FontSize = 12;
            
            % Set Friendly Name
            friendlyName = ['X_' plotSettings.xValueName...
                           '_Y_' plotSettings.yValueName];
            data = struct('friendlyName', friendlyName);
            plotFigure.UserData = data;
            
            lineWidth = 2;
            
            % Set Axis Labels
            xlabel(plotSettings.xLabel);
            ylabel(plotSettings.yLabel);
            
            % Setup Legend
            legendStrs = {};
            legendPlots = [];
            
            % Setup Marker Order
            markers = plotSettings.markerOrder;
            
            hold on;
            
            for plotLine = plotSettings.plotMap.keys
                % For Every Voltage stored in Map
                self.plotIntResults =  plotSettings.plotMap(plotLine{1});
                xValues = [self.plotIntResults.(plotSettings.xValueName)] * plotSettings.xScale;
                yValues = [self.plotIntResults.(plotSettings.yValueName)] * plotSettings.yScale;
                plotObj = plot(xValues, yValues);
                plotObj.LineWidth = lineWidth;
                plotObj.LineStyle = 'none';
                plotObj.MarkerSize = 10;
                plotObj.Marker = markers{1};
                markers = circshift(markers, [-1, 0]);
                legendStrs{end+1} = [' ' num2str(plotLine{1}) ' ' plotSettings.legendSuffix]; %#ok<AGROW>
                legendPlots(end+1) = plotObj; %#ok<AGROW>
                
                % Extrapolate
                p = polyfit(xValues, yValues, 2);
                currents = 0:35;
                curve_x = polyval(p, currents);
                trendLine = line(currents, curve_x);
                trendLine.Color = plotObj.Color;
                trendLine.LineStyle = '--';
                trendLine.LineWidth = lineWidth;
            end
            
            hold off;
            
            plotLegend = legend(legendPlots, legendStrs);
            plotLegend.Location = plotSettings.legendLocation;
        end
        function [plotFigure] = plotEOn(self)
            plotSettings = SweepPlotSettings;
            plotSettings.title = 'Turn On Energy Loss';
            plotSettings.xLabel = 'Load Current (A)';
            plotSettings.xValueName = 'loadCurrent';
            plotSettings.yLabel = 'E_{ON} (\muJ)';
            plotSettings.yValueName = 'turnOnEnergy';
            plotSettings.yScale = 1e6;
            
            plotSettings.plotMap = self.chan2ByVoltage;
            
            [plotFigure] = self.plotSweep(plotSettings);
        end
        function [plotFigure] = plotEOff(self)
            plotSettings = SweepPlotSettings;
            plotSettings.title = 'Turn Off Energy Loss';
            plotSettings.xLabel = 'Load Current (A)';
            plotSettings.xValueName = 'loadCurrent';
            plotSettings.yLabel = 'E_{OFF} (\muJ)';
            plotSettings.yValueName = 'turnOffEnergy';
            plotSettings.yScale = 1e6;
            
            plotSettings.plotMap = self.chan2ByVoltage;
            
            [plotFigure] = self.plotSweep(plotSettings);
        end
        function [surfFigure, surfObj, ax] = plotSurfacePlot(~, surfacePlotSettings)
            % Plot Surface
            sps = surfacePlotSettings;
            
            % Extract Data points from supplied map
            keyset = sps.plotMap.keys;
            valueSet = values(sps.plotMap, keyset);
            fullResults = [valueSet{:}];
            
            x = [fullResults.(sps.xValueName)] * sps.xScale;
            y = [fullResults.(sps.yValueName)] * sps.yScale;
            z = [fullResults.(sps.zValueName)] * sps.zScale;
            
            F = scatteredInterpolant(x.', y.', z.');
            
            sx = sps.xSamples;
            sy = sps.ySamples;
            
            [xq, yq] = meshgrid(sx, sy);
            zq = F(xq, yq);
            % zq = griddata(x, y, z, xq, yq, 'natural');
            
            surfFigure = figure;
            friendlyName = ['Z_' sps.zValueName...
                           '_X_' sps.xValueName...
                           '_Y_' sps.yValueName];
            data = struct('friendlyName', friendlyName);
            surfFigure.UserData = data;
            surfObj = surf(xq, yq, zq);
            surfObj.LineStyle = 'none';
            
            temp = title(sps.title);
            if strfind(sps.title, '$$')
                temp.Interpreter = 'latex';
            end
            temp = xlabel(sps.xLabel);
            if strfind(sps.xLabel, '$$')
                temp.Interpreter = 'latex';
            end
            temp = ylabel(sps.yLabel);
            if strfind(sps.yLabel, '$$')
                temp.Interpreter = 'latex';
            end
            temp = zlabel(sps.zLabel);
            if strfind(sps.zLabel, '$$')
                temp.Interpreter = 'latex';
            end
            
            ax = gca;
        end
        function [surfFigure, surfObj, ax] = plotEOnSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Turn On Energy Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = 'E_{ON} (\muJ)';
            sps.zValueName = 'turnOnEnergy';
            sps.zScale = 1e6;
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotEOffSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Turn Off Energy Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = 'E_{OFF} (\muJ)';
            sps.zValueName = 'turnOffEnergy';
            sps.zScale = 1e6;
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotPeakOnVSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Peak Turn On V_{DS} Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = 'T_{VR} (ns)';
            sps.zValueName = 'turnOnPeakVDS';
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotPeakOffVSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Peak Turn Off V_{DS} Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = 'T_{VR} (ns)';
            sps.zValueName = 'turnOffPeakVDS';
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotVdsOnIntSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Turn On $$\int V_{DS}dt$$ Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = '$$ \int V_{DS} $$';
            sps.zValueName = 'turnOnVDSInt';
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotVdsOffIntSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Turn Off $$\int V_{DS}dt$$ Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = '$$ \int V_{DS} $$';
            sps.zValueName = 'turnOffVDSInt';
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotIdOnIntSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Turn On $$\int I_{D}dt$$ Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = '$$ \int I_{D} $$';
            sps.zValueName = 'turnOnIDInt';
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotIdOffIntSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Turn Off $$\int I_{D}dt$$ Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = '$$ \int I_{D} $$';
            sps.zValueName = 'turnOffIDInt';
            
            sps.plotMap = self.chan2ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
        function [surfFigure, surfObj, ax] = plotTVRSurface(self)
            % Plot Surface plot of turn on energy
            sps = SurfacePlotSettings;
            
            sps.title = 'Voltage Rise Time Surface Plot';
            sps.xLabel = 'Bus Voltage (V)';
            sps.xValueName = 'busVoltage';
            sps.yLabel = 'Load Current (A)';
            sps.yValueName = 'loadCurrent';
            sps.zLabel = 'T_{VR} (ns)';
            sps.zValueName = 'voltageRiseTime';
            sps.zScale = 1e9;
            
            sps.plotMap = self.chan4ByVoltage;

            [surfFigure, surfObj, ax] = self.plotSurfacePlot(sps);
        end
    end
    
end


