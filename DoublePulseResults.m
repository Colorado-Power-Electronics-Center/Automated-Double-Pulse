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
        ivMisalignment
        
        % Turn On Properties
        turnOnEnergy
        turnOnDelay        
        voltageFallTime
        currentRiseTime
        turnOnTime
        turnOnPeakDV_DT
        
        % Turn Off Properties
        turnOffEnergy
        turnOffDelay
        voltageRiseTime
        turnOffPeakDV_DT
    end
    
    properties (Access = private)
        % Turn On
        gateTurnOnIdx
        currentTurnOnIdx
        v_ds_at0Idx
        
        % Turn Off
        gateTurnOffIdx
    end
    
    methods
        % Constructor
        function self = DoublePulseResults(onWaveforms, offWaveforms)
            if nargin > 0
                self.turnOnWaveform = onWaveforms;
                self.turnOffWaveform = offWaveforms;
                
                %% Calculate Values
                % Nominal Values
                self.busVoltage = self.calcBusVoltage;
                self.loadCurrent = self.calcLoadCurrent;
                self.gateVoltage = self.calcGateVoltage;
                
                % IV Misalignment
                self.ivMisalignment = calcIVMisalignment;
                if self.ivMisalignment > 500e-12
                    warning('IV Misalignment greater than 500 pS');
                end
                
                % Turn On indicies
                self.gateTurnOnIdx = self.calcGateTurnOnIdx;
                self.currentTurnOnIdx = self.calcCurrentTurnOnIdx;
                
                % Current Rise, Voltage Fall, and turn on times
                self.currentRiseTime = calcCurrentRiseTime;
                self.voltageFallTime = calcVoltageFallTime;
                self.turnOnTime = calcTurnOnTime;
            end
        end
    end
    
    methods (Access = private)
        function busVoltage = calcBusVoltage(self)
            % Calculate the Bus Voltage by finding the average of V_DS from 
            % the start of the turn on waveform to 1/4 of the time until
            % turn on.
            stopIdx = floor(self.turnOnWaveform.switchIdx / 2);
            beforeSwitchVDS = self.turnOnWaveform.v_ds(1:stopIdx);
            
            busVoltage = mean(beforeSwitchVDS);
        end
        function loadCurrent = calcLoadCurrent(self)
            % Calculate the load current by taking the mean of the
            % Drain Current from 25 ns before the turn off until 5 ns
            % before turn off. 
            pointsInTime = @(t) self.turnOnWaveform.sampleRate * t;
            
            startIdx = self.turnOffWaveform.switchIdx - pointsInTime(25e-9);
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
        function gateOnIdx = calcGateTurnOnIdx(self)
            % Find Gate Turn on idx
            % Point in V_GS turn on waveform where voltage starts to increase and 
            % does not stop increasing
            gateOnIdx = findOnIdx(self.turnOnWaveform.v_gs, self.gateVoltage);
        end
        function currentOnIdx = calcCurrentTurnOnIdx(self)
            % Find Current Turn on idx
            % Point in I_D turn on waveform where current starts to increase and
            % does not stop increasing
            currentOnIdx = findOnIdx(self.turnOnWaveform.i_d, self.loadCurrent);
        end
        function turnOnDelay = calcTurnOnDelay(self)
            % Find turn on delay, td_on, the time from gate rise start to current
            % rise start.
            t_d_onIdx = self.currentTurnOnIdx - self.gateTurnOnIdx;
            turnOnDelay = t_d_onIdx * self.turnOnWaveform.samplePeriod;
        end
        function curRiseTime = calcCurrentRiseTime(self)
            % Find Current Rise time, t_cr, the time for the current to rise from 0
            % to the load current.
            id_atLoadIdx = find(self.turnOnWaveform.i_d > self.loadCurrent, 1);
            t_cr_idx = id_atLoadIdx - self.currentTurnOnIdx;
            curRiseTime = t_cr_idx * self.turnOnWaveform.samplePeriod;
        end
        function voltageFallTime = calcVoltageFallTime(self)
            % Find Voltage Fall time, t_vf, the time it takes for the voltage to
            % reach zero after the voltage starts falling. We can say that the
            % voltage will start falling at the same time the current starts
            % rising.
            self.v_ds_at0Idx = find(self.turnOnWaveform.v_ds < 0, 1);
            t_vf_idx = self.v_ds_at0Idx - self.currentTurnOnIdx;
            voltageFallTime = t_vf_idx * self.turnOnWaveform.samplePeriod;
        end
        function turnOnTime = calcTurnOnTime(self)
            % Calculate on time, t_on, the time from intial V_GS rise to final
            % V_DS fall. 
            t_on_idx = self.v_ds_at0Idx - self.gateTurnOnIdx;
            turnOnTime = t_on_idx * self.turnOnWaveform.samplePeriod;
        end
        function [onIdx] = findOnIdx(onWaveform, peakValue)
            on_diff = diff(onWaveform);
            half_on_idx = find(onWaveform > peakValue / 2, 1);
            onIdx = find(on_diff(1:half_on_idx) < 0, 1, 'last') + 1;
        end
        function ivMisalignment = calcIVMisalignment(self)
            % Use di/dt method to deskew voltage and current measurements.
            % Returns the delay in the curent signal, e.g. if the current lags the
            % voltage by 5ns the function will return +5ns.
            
            % Unpack Needed Variables
            V_bus = self.busVoltage;
            I_load = self.loadCurrent;
            voltage = self.turnOnWaveform.v_ds;
            current = self.turnOnWaveform.i_d;
            time = self.turnOnWaveform.time;
            
            % Maximum Allowable Skew
            max_skew  = 5e-9;
            % Minimum Desired Skew
            min_skew  = 10e-12;
            
            % Interpolate waveform to find skew more precisely
            f_time = time(1) : min_skew : time(end);
            f_voltage = interp1(time, voltage, f_time, 'spline') - V_bus;
            f_current = interp1(time, current, f_time, 'spline');
            
            % Find starting and stoping indexs for current
            i_start = find(f_current - 0.1 * I_load < 0, 1, 'last');
            i_end = find(f_current - 0.9 * I_load > 0, 1);
            i_start = 2 * i_start - i_end;

            % Find starting and stopping indexs for voltage
            v_start = max(1, round(i_start - max_skew / min_skew));
            v_end = min(numel(f_voltage), round(i_end + max_skew / min_skew));
            
            % Slice Current and Voltage Waveforms
            on_current = f_current(i_start:i_end);
            on_voltage = f_voltage(v_start:v_end);

            % Take derivative of Current
            di_dt = diff(on_current) / min_skew;

            % Find unadjusted delay
            u_delay = finddelay(on_voltage, di_dt);

            % Adjust delay to take into account differing sizes of on_voltage and
            % di_dt.
            idx_delay = u_delay + (i_start - v_start);

            % Convert Delay to time
            ivMisalignment = idx_delay * min_skew;
        end
    end
    methods (Access = public, Static)
        function ivMisalignment = findIVMisalignment(fullWaveforms)
            % Create DoublePulseResults Object from Full Waveform
            DPResults = DoublePulseResults(fullWaveforms.turnOnWaveform,...
                                           fullWaveforms.turnOffWaveform);
                                       
            % Find Bus Voltage and Load Current
            DPResults.calcBusVoltage;
            DPResults.calcLoadCurrent;
            
            % Find IV Misalignment
            DPResults.ivMisalignment = DPResults.calcIVMisalignment;
            
            % Return
            ivMisalignment = DPResults.ivMisalignment;
            
        end
    end
    
    
end

