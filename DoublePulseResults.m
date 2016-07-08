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
        pOn
        
        % Turn Off Properties
        turnOffEnergy
        turnOffDelay
        voltageRiseTime
        turnOffTime
        turnOffPeakDV_DT
        pOff
    end
    
    properties (Access = private)
        % Turn On
        gateTurnOnIdx
        currentTurnOnIdx
        v_ds_at0Idx
        
        % Turn Off
        gateTurnOffIdx
        currentTurnOffIdx
        vDSatBus
    end
    
    methods
        % Constructor
        function self = DoublePulseResults(onWaveforms, offWaveforms)
            if nargin > 0
                self.turnOnWaveform = onWaveforms;
                self.turnOffWaveform = offWaveforms;
                
                %% Calculate Values
                % Nominal Values
                self.calcBusVoltage;
                self.calcLoadCurrent;
                self.calcGateVoltage;
                
                % Turn On indicies
                self.calcGateTurnOnIdx;
                self.calcCurrentTurnOnIdx;
                
                % Turn Off indicies
                self.calcGateTurnOffIdx;
                self.calcCurrentTurnOffIdx;
                
                % IV Misalignment
                self.calcIVMisalignment;
                if self.ivMisalignment > 500e-12
                    warning('IV Misalignment greater than 500 pS');
                end
                
                
                
                % Current Rise, Voltage Fall, and turn on times
                self.calcCurrentRiseTime;
                self.calcVoltageFallTime;
                self.calcTurnOnTime;
                self.calcTurnOnDelay;
                
                % Voltage Rise, turn off times
                self.calcVoltageRiseTime;
                self.calcTurnOffTime;
                self.calcTurnOffDelay;
                
                % Calculate Maximum DV/DT in turn off and turn on V_DS
                self.calcTurnOnPeakDV_DT;
                self.calcTurnOffPeakDV_DT;
                
                % Calculate Turn On Energy
                self.calcTurnOnEnergy;
                
                % Calculate Turn Off Energy
                self.calcTurnOffEnergy;
            end
        end
        
        function pubCalcIvMis(self)
            self.calcIVMisalignment;
        end
    end
    
    methods (Access = private)
        function calcBusVoltage(self)
            % Calculate the Bus Voltage by finding the average of V_DS from 
            % the start of the turn on waveform to 1/4 of the time until
            % turn on.
            stopIdx = floor(self.turnOnWaveform.switchIdx / 2);
            beforeSwitchVDS = self.turnOnWaveform.v_ds(1:stopIdx);
            
            self.busVoltage = mean(beforeSwitchVDS);
        end
        function calcLoadCurrent(self)
            % Calculate the load current by taking the mean of the
            % Drain Current from start of turn off window until 5 ns
            % before turn off. 
            pointsInTime = @(t) floor(self.turnOnWaveform.sampleRate * t);
            
            startIdx = 1;
            endIdx = self.turnOffWaveform.switchIdx - pointsInTime(5e-9);
            beforeSwitchID = self.turnOffWaveform.i_d(startIdx:endIdx);
            
            self.loadCurrent = mean(beforeSwitchID);
        end
        function calcGateVoltage(self)
            % Calculate the gate voltage by finding the average of the
            % values from the start of the turn off waveform to 1/4 of the
            % time until turn off.
            stopIdx = floor(self.turnOffWaveform.switchIdx / 2);
            beforeSwitchVGS = self.turnOffWaveform.v_gs(1:stopIdx);
            
            self.gateVoltage = mean(beforeSwitchVGS);
        end
        function calcGateTurnOnIdx(self)
            % Find Gate Turn on idx
            % Point in V_GS turn on waveform where voltage starts to 
            % increase and does not stop increasing.
            self.gateTurnOnIdx = self.findOnIdx(self.turnOnWaveform.v_gs, self.gateVoltage);
        end
        function calcGateTurnOffIdx(self)
            % Find Gate Turn off idx
            % Point in V_GS turn off waveform where voltage starts to fall
            % and does not stop decreasing.
            self.gateTurnOffIdx = self.findOffIdx(self.turnOffWaveform.v_gs);
        end
        function calcCurrentTurnOnIdx(self)
            % Find Current Turn on idx
            % Point in I_D turn on waveform where current starts to 
            % increase and does not stop increasing
            self.currentTurnOnIdx = self.findOnIdx(self.turnOnWaveform.i_d, self.loadCurrent);
        end
        function calcCurrentTurnOffIdx(self)
            % Find Current Turn Off idx
            % Point in I_D turn off waveform where current starts to
            % decrease and does not stop decreasing.
            self.currentTurnOffIdx = self.findOffIdx(self.turnOffWaveform.i_d);
        end
        function calcTurnOnDelay(self)
            % Find turn on delay, td_on, the time from gate rise start to current
            % rise start.
            t_d_onIdx = self.currentTurnOnIdx - self.gateTurnOnIdx;
            self.turnOnDelay = t_d_onIdx * self.turnOnWaveform.samplePeriod;
        end
        function calcTurnOffDelay(self)
            % Find turn off delay, td_off, the time from the start of the
            % gate fall to the start of the current fall.
            tdOffIdx = self.currentTurnOffIdx - self.gateTurnOffIdx;
            self.turnOffDelay = tdOffIdx * self.turnOffWaveform.samplePeriod;
        end
        function calcCurrentRiseTime(self)
            % Find Current Rise time, t_cr, the time for the current to rise from 0
            % to the load current.
            id_atLoadIdx = find(self.turnOnWaveform.i_d > self.loadCurrent, 1);
            t_cr_idx = id_atLoadIdx - self.currentTurnOnIdx;
            self.currentRiseTime = t_cr_idx * self.turnOnWaveform.samplePeriod;
        end
        function calcVoltageFallTime(self)
            % Find Voltage Fall time, t_vf, the time it takes for the voltage to
            % reach zero after the voltage starts falling. We can say that the
            % voltage will start falling at the same time the current starts
            % rising.
            self.v_ds_at0Idx = find(self.turnOnWaveform.v_ds < 0, 1);
            t_vf_idx = self.v_ds_at0Idx - self.currentTurnOnIdx;
            self.voltageFallTime = t_vf_idx * self.turnOnWaveform.samplePeriod;
        end
        function calcVoltageRiseTime(self)
            % Find Voltage Rise time, t_vr, the time it takes for the
            % voltage to reach the bus after the voltage starts rising. We
            % can say that the voltage will start rising at the same time
            % the current starts falling.
            self.vDSatBus = find(self.turnOffWaveform.v_ds > self.busVoltage, 1);
            tVRidx = self.vDSatBus - self.currentTurnOffIdx;
            self.voltageRiseTime = tVRidx * self.turnOffWaveform.samplePeriod;
        end
        function calcTurnOnTime(self)
            % Calculate on time, t_on, the time from intial V_GS rise to final
            % V_DS fall. 
            t_on_idx = self.v_ds_at0Idx - self.gateTurnOnIdx;
            self.turnOnTime = t_on_idx * self.turnOnWaveform.samplePeriod;
        end
        function calcTurnOffTime(self)
            % Calculate off time, t_off, the time from intial V_GS fall to
            % V_DS reaching the Bus Voltage.
            tOffIdx = self.vDSatBus - self.gateTurnOffIdx;
            self.turnOffTime = tOffIdx * self.turnOffWaveform.samplePeriod;
        end
        function calcTurnOnPeakDV_DT(self)
            % Calculate the peak DV/DT in V_DS during the turn on time
            % period.
            % Find V_DS turn on 10% and 90% on point
            onWF = self.turnOnWaveform.v_ds;
            % Device is 10% on when V_DS has dropped from the bus voltage
            % to 90% of the Bus Voltage
            on10Idx = find(onWF > .9 * self.busVoltage, 1, 'last');
            % Device is 90% on when V_DS has dropped to 10% of the bus
            % voltage.
            on90Idx = find(onWF < .1 * self.busVoltage, 1);
            
            % Create vector from 10% on to 90% on
            onEdge = onWF(on10Idx:on90Idx);
            
            % find DV/DT 
            dv_dt = diff(onEdge) / self.turnOnWaveform.samplePeriod;
            
            % Max DV/DT 
            self.turnOnPeakDV_DT = max(abs(dv_dt));
        end
        function calcTurnOffPeakDV_DT(self)
            % Calculate the peak DV/DT in V_DS during the turn off time
            % period.
            % Find V_DS turn on 10% and 90% on point
            offWF = self.turnOffWaveform.v_ds;
            % Device is 10% off when V_DS has risen from 0 to 10% of the 
            % Bus Voltage.
            oFF10Idx = find(offWF > .1 * self.busVoltage, 1, 'last');
            % Device is 90% on when V_DS has dropped to 10% of the bus
            % voltage.
            off90Idx = find(offWF < .9 * self.busVoltage, 1);
            
            % Create vector from 10% on to 90% on
            offEdge = offWF(oFF10Idx:off90Idx);
            
            % find DV/DT 
            dv_dt = diff(offEdge) / self.turnOffWaveform.samplePeriod;
            
            % Max DV/DT 
            self.turnOnPeakDV_DT = max(abs(dv_dt));
        end
        function calcTurnOnEnergy(self)
            % Calculate the energy loss during turn on.
            % Find the power
            self.pOn = self.turnOnWaveform.v_ds .* self.turnOffWaveform.i_d;
            
            % Find Energy loss during switching
            eOnCum = cumtrapz(self.turnOnWaveform.time, self.pOn);
            
            eOn = eOnCum(self.v_ds_at0Idx) - eOnCum(self.currentTurnOnIdx);
            % Set Loss
            self.turnOnEnergy = eOn;            
        end
        function calcTurnOffEnergy(self)
            % Calculate the energy loss during turn off
            % Find the power
            self.pOff = self.turnOffWaveform.v_ds .* self.turnOffWaveform.i_d;
            
            % find energy loss during switching
            eOffCum = cumtrapz(self.turnOffWaveform.time, self.pOff);
            
            eOff = eOffCum(self.vDSatBus) - eOffCum(self.currentTurnOffIdx);
            
            % Set loss
            self.turnOffEnergy = eOff;
        end
        function calcIVMisalignment(self)
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
            i_pastHalf = find(f_current > .5 * I_load, 1);
            i_start = find(f_current(1:i_pastHalf) - 0.1 * I_load < 0, 1, 'last');
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
            self.ivMisalignment = idx_delay * min_skew;
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
            DPResults.calcIVMisalignment;
            
            % Return
            ivMisalignment = DPResults.ivMisalignment;
            
        end
    end
    methods (Access = protected, Static)
        function [onIdx] = findOnIdx(onWaveform, peakValue)
            on_diff = diff(onWaveform);
            half_on_idx = find(onWaveform > peakValue / 2, 1);
            onIdx = find(on_diff(1:half_on_idx) < 0, 1, 'last') + 1;
        end
        function [offIdx] = findOffIdx(offWaveform)
            % Find point in offWaveform where value starts decreasing and
            % does not stop decreasing.
            offDiff = diff(offWaveform);
            
            % Half off value is aproximately the average of the entire
            % waveform.
            halfOffValue = mean(offWaveform);
            
            % Find half off idx
            halfOffIdx = find(offWaveform < halfOffValue, 1);
            
            % offIdx is point before halfOffIdx where value starts to
            % decrease and does not stop.
            offIdx = find(offDiff(1:halfOffIdx) > 0, 1, 'last') + 1;
        end
    end
    
    
end

