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
        voltageResults@DoublePulseResults vector
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
        function plotEOn(self)
            % Function to create plot for the turn on Energy Loss with 2
            % Channel Waveforms
            eOnFigure = figure;
            eOnFigure.Name = 'Turn On Energy Loss';
            eOnFigure.NumberTitle = 'off';
            
            % Set Axis Labels
            xlabel('Load Current (A)');
            ylabel('E_{ON} (\muJ)');
            
            % Setup Legend
            legendStrs = {};
            
            % Setup Marker Order
            markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'}.';
            
            hold on;
            
            for voltage = self.chan4ByVoltage.keys
                % For Every Voltage stored in Map
                self.voltageResults = self.chan4ByVoltage(voltage{1});
                currents = [self.voltageResults.loadCurrent];
                turnOnEnergies = [self.voltageResults.turnOnEnergy] * 1e6;
                plotObj = plot(currents, turnOnEnergies);
                plotObj.Marker = markers{1};
                markers = circshift(markers, [-1, 0]);
                legendStrs{end+1} = [num2str(voltage{1}) ' V'];
            end
            
            hold off;
            
            plotLegend = legend(legendStrs);
            plotLegend.Location = 'NorthWest';
            
        end
    end
    
end

