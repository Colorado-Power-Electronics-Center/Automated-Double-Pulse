classdef DoublePulseResults < matlab.mixin.Copyable
    %DoublePulseResults Stores the results of a double Pulse Test.
    %   Also contains methods for processing the results of a double pulse
    %   test. Can be included in a SweepResults object to allow for
    %   contruction of a sweep result.
    
    properties
        turnOnWaveform@SwitchWaveform
        turnOffWaveform@SwitchWaveform
        
        % Shared Properties
        busVoltage
        loadCurrent
        gateVoltage
        
        % Turn On Properties
        turnOnEnergy
        turnOnDelay
        voltageFallTime
        turnOnPeakDV_DT
        
        % Turn Off Properties
        turnOffEnergy
        turnOffDelay
        voltageRiseTime
        turnOffPeakDV_DT
    end
    
    properties (Access = private)
        % Turn On
        turnOnIdx
        gateTurnOnIdx
        
        % Turn Off
        turnOffIdx
        gateTurnOffIdx
    end
    
    methods
        % Constructor
        function self = DoublePulseResults(onWaveforms, offWaveforms)
            if nargin > 0
                self.turnOnWaveform = onWaveforms;
                self.turnOffWaveform = offWaveforms;
                
                % Calculate Values
                self.busVoltage = self.calcBusVoltage;
                self.loadCurrent = self.calcLoadCurrent;
                self.gateVoltage = self.calcGateVoltage;
            end
        end
    end
    
    methods (Access = private)
        function busVoltage = calcBusVoltage(self)
            % Calculate the Bus Voltage by finding the average of V_DS from 
            % the start of the turn on waveform to 1/4 of the time until
            % turn on.
            stopIdx = floor(self.turnOnIdx / 2);
            beforeSwitchVDS = self.turnOnWaveform.v_ds(1:stopIdx);
            
            busVoltage = mean(beforeSwitchVDS);
        end
        function loadCurrent = calcLoadCurrent(self)
            % Calculate the load current by taking the mean of the
            % Drain Current from 25 ns before the turn off until 5 ns
            % before turn off. 
            pointsInTime = @(t) self.turnOnWaveform.sampleRate * t;
            
            startIdx = self.turnOffIdx - pointsInTime(25e-9);
            endIdx = self.turnOffIdx - pointsInTime(5e-9);
            beforeSwitchID = self.turnOffWaveform.i_d(startIdx:endIdx);
            
            loadCurrent = mean(beforeSwitchID);
        end
        function gateVoltage = calcGateVoltage(self)
            % Calculate the gate voltage by finding the average of the
            % values from the start of the turn off waveform to 1/4 of the
            % time until turn off.
            stopIdx = floor(self.gateTurnOffIdx / 2);
            beforeSwitchVGS = self.turnOffWaveform(1:stopIdx);
            
            gateVoltage = mean(beforeSwitchVGS);
        end
    end
    
    
end

