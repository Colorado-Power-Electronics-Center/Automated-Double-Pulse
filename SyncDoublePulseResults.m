%{
    Part of the Automated Double Pulse Test Project
    Copyright (C) 2017  Kyle Goodrick

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Kyle Goodrick: Kyle.Goodrick@Colorado.edu
%}

classdef SyncDoublePulseResults < matlab.mixin.Copyable
    %SyncDoublePulseResults Stores the results of a double Pulse Test.
    %   Also contains methods for processing the results of a double pulse
    %   test. Can be included in a SweepResults object to allow for
    %   construction of a sweep result.
    
    properties
        turnOnWaveform@SwitchWaveform
        turnOffWaveform@SwitchWaveform
        
        fullWaveform@FullWaveform
        
        numChannels
        
        % Shared Properties
        busVoltage
        loadCurrent
%         gateVoltage
        
        % Turn On Properties
        turnOnEnergy
        voltageFallTime
        currentRiseTime
        turnOnPeakDV_DT
        pOn
        turnOnPeakVDS
        turnOnVDSInt
        turnOnIDInt
        
        % Turn Off Properties
        turnOffEnergy
        voltageRiseTime
        turnOffPeakDV_DT
        pOff
        turnOffPeakVDS
        turnOffVDSInt
        turnOffIDInt
    end
    
    properties (Access = private)
        % Turn On
        currentTurnOnIdx
        v_ds_at0Idx
        
        % Turn Off
        currentTurnOffIdx
        vDSatBus
    end
    
    methods
        % Constructor
        function self = SyncDoublePulseResults(onWaveforms, offWaveforms)
            self.turnOnWaveform = SwitchWaveform;
            self.turnOffWaveform = SwitchWaveform;

            self.fullWaveform = FullWaveform;
            if nargin > 0
                self.turnOnWaveform = onWaveforms;
                self.turnOffWaveform = offWaveforms;
                
                % Determine Number of Channels
                if self.turnOnWaveform.v_gs == GeneralWaveform.NOT_RECORDED;
                    self.numChannels = 2;
                else
                    self.numChannels = 4;
                end
                
                self.calcAllValues;
            end
        end
        %% shiftCurrent: Shift Current By nanoSec ns. A positive value 
        % will shift to the right and a negative value will shift to the left.
        function shiftCurrent(self, nanoSec)
            % if self contains more than one DoublePulseResult handle run
            % function one at a time.
            if numel(self) > 1
                for obj = self
                    obj.shiftCurrent(nanoSec)
                end

                return;
            end

            % Determine number of indices to shift current
            numIdx = round(abs(nanoSec * 1E-9) * self.turnOnWaveform.sampleRate);

            % Create array of ones to shift current
            shiftPoints = ones(1, numIdx);

            % Add array to beginning or end of current array depending on
            % sign of nanoSec.
            if nanoSec > 0 % Add to beginning (shift right)
                turnOnShift = shiftPoints * self.turnOnWaveform.i_d(1);
                turnOffShift = shiftPoints * self.turnOffWaveform.i_d(1);

                self.turnOnWaveform.i_d = [turnOnShift self.turnOnWaveform.i_d(1:end - numIdx)];
                self.turnOffWaveform.i_d = [turnOffShift self.turnOffWaveform.i_d(1:end - numIdx)];
            else % Add to end (shift left)
                turnOnShift = shiftPoints * self.turnOnWaveform.i_d(end);
                turnOffShift = shiftPoints * self.turnOffWaveform.i_d(end);

                self.turnOnWaveform.i_d = [self.turnOnWaveform.i_d(1 + numIdx:end) turnOnShift];
                self.turnOffWaveform.i_d = [self.turnOffWaveform.i_d(1 + numIdx:end) turnOffShift];
            end

            % Recalculate Values
            self.calcAllValues;
        end
        function calcAllValues(self)
            % If self contains more than one DoublePulseResult handle run
            % function one at a time.
            if numel(self) > 1
                for obj = self
                obj.calcAllValues
                end
                
                return;
            end
            % Run all calculation methods
            % Nominal Values
            self.calcBusVoltage;
            self.calcLoadCurrent;
%             if self.numChannels == 4
%                 self.calcGateVoltage;       
%             end
            
            % Calculate Peak V_DS
            self.calcPeakVDS;

            % Turn On indices
%             if self.numChannels == 4
%                 self.calcGateTurnOnIdx;
%             end
            self.calcCurrentTurnOnIdx;

            % Turn Off indices
%             if self.numChannels == 4
%                 self.calcGateTurnOffIdx;
%             end
            self.calcCurrentTurnOffIdx;

            % Current Rise, Voltage Fall, and turn on times
            self.calcCurrentRiseTime;
            self.calcVoltageFallTime;
%             if self.numChannels == 4
%                 self.calcTurnOnTime;
%                 self.calcTurnOnDelay;
%             end

            % Voltage Rise, turn off times
            self.calcVoltageRiseTime;
%             if self.numChannels == 4
%                 self.calcTurnOffTime;
%                 self.calcTurnOffDelay;
%             end

            % Calculate Maximum DV/DT in turn off and turn on V_DS
            self.calcTurnOnPeakDV_DT;
            self.calcTurnOffPeakDV_DT;

            % Calculate Turn On Energy
            self.calcTurnOnEnergy;

            % Calculate Turn Off Energy
            self.calcTurnOffEnergy;
            
            % Calculate Integrals
            self.calcOnIntegrals;
            self.calcOffIntegrals;
        end
        
        
        function dispResults(self)
            % Output results to the command window
            disp('Turn-off waveform analysis:');
            fprintf('\n V_dc         %4.0f V', self.busVoltage);
            fprintf('\n I_L          %4.1f A', self.loadCurrent);
            fprintf('\n Eoff         %4.1f uJ', self.turnOffEnergy * 1e6);
%             fprintf('\n td_off       %4.1f ns', self.turnOffTime * 1e9);
            fprintf('\n tvr          %4.1f ns', self.voltageRiseTime * 1e9);
            fprintf('\n Peak dv/dt   %4.1f V/ns \n\n', self.turnOffPeakDV_DT / 1e9);
            disp('Turn-on waveform analysis:');
            fprintf('\n V_dc         %4.0f V', self.busVoltage);
            fprintf('\n I_L          %4.1f A', self.loadCurrent);
            fprintf('\n Eon          %4.1f uJ', self.turnOnEnergy * 1e6);
%             fprintf('\n td_on        %4.1f ns', self.turnOnDelay * 1e9);
            fprintf('\n tcr          %4.1f ns', self.currentRiseTime * 1e9);
            fprintf('\n tvf          %4.1f ns', self.voltageFallTime * 1e9);
            fprintf('\n Peak dv/dt   %4.1f V/ns \n', self.turnOnPeakDV_DT / 1e9);
        end
        
        function plotResults(self)
            % If self contains more than one DoublePulseResult handle run
            % function one at a time.
            if numel(self) > 1
                for obj = self
                obj.plotResults
                end
                
                return;
            end
            
            % Plot Results in several figures
            % Plot Turn On Waveform
            self.plotWaveform(self.turnOnWaveform, 'Turn On Waveform', self.pOn)
            
            % Plot Turn Off Waveform
            self.plotWaveform(self.turnOffWaveform, 'Turn Off Waveform', self.pOff)
            
            % Plot Overview Waveform
            self.plotWaveform(self.fullWaveform, 'Overview Waveform')
        end
        
        function plotWaveform(self, waveform, name, power)
            % Set Colors
            vdsColor = [0.9290    0.6940    0.1250];
            vgsColor = [0    0.4470    0.7410];
            idColor = [0.8500    0.3250    0.0980];
%             ilColor = 'magenta';
            powerColor = 'black';
            
            % Set other plot values
            lineWidth = 3;
            fontSize = 12;
            
            % Check if Switch or full waveform
            isSwitch = isa(waveform, 'SwitchWaveform');
            
            if isSwitch
                % Find VGS Scaling Factor
%                 if self.numChannels == 4
%                     vgsScaling = self.busVoltage / self.gateVoltage;
%                 end

                % Change time to nS
                time = waveform.time * 1e9;
                timeUnits = 'ns';
            else
                % Most common value function
                mostCom = @(x) mode(round(x(x > mean(x))));
                
                % Find approximate Bus and gate Voltage
%                 if self.numChannels == 4
%                     approxGateVoltage = mostCom(waveform.v_gs);
%                 
%                     approxBusVoltage = mostCom(waveform.v_ds);
%                     % Find VGS Scaling Factor
%                     vgsScaling = approxBusVoltage / approxGateVoltage;
%                 end
                
                % Change time to uS
                time = waveform.time * 1e6;
                timeUnits = '\mus';
            end
            
            % Round VGS Scaling to nearest 10
%             if self.numChannels == 4
%                 vgsScaling = floor(vgsScaling / 10) * 10;
%                 if vgsScaling == 0, vgsScaling = 1; end
%             end
            
            % Plot Waveform
            switchFigure = figure();
            switchFigure.Name = name;
            switchFigure.NumberTitle = 'off';
            
            % Setup Figure
            
            % Setup Power Subplot
            if isSwitch
                powerSubPlot = subplot(2, 1, 1);
                powerSubPlot.XGrid = 'on';
                powerSubPlot.YGrid = 'on';
                powerSubPlot.Position = [0.1200, 1-.22, 0.7750, 0.2];
                powerSubPlot.XAxis.Visible = 'off';
                powerSubPlot.YAxis.Visible = 'off';
                powerSubPlot.FontSize = fontSize;

                powerLine = line(powerSubPlot, time, power);
                powerLine.Color  = powerColor;
                powerLine.LineWidth = lineWidth;

                powerLegend = legend('Power');
                powerLegend.Location = 'northwest';
                
                powerYAxis = powerSubPlot.YAxis;
                buffer = (max(power) - min(power)) * .05;
                powerYAxis.Limits = [min(power) - buffer,...
                                     max(power) + buffer];
                                 
                % Setup Measured subplot
                measSubP = subplot(2, 1, 2);
                measSubP.Position = [0.1200, 0.010, 0.7750, 0.76];
            else
                % Setup Measured subplot
                measSubP = gca;
                measSubP.Position = [0.1200, 0.010, 0.7750, .97];
            end
            
            measSubP.XGrid = 'on';
            measSubP.YGrid = 'on';
            measSubP.FontSize = fontSize;
            
            xlabel(['Time (' timeUnits ')']);
            
            legendStrs = {};
            
            % V_DS
            yyaxis left
            ylabel('Voltage (V)')
            measSubP.YColor = 'black';
            vdsOnLine = line(time, waveform.v_ds);
            vdsOnLine.Color = vdsColor;
            vdsOnLine.LineWidth = lineWidth;
            legendStrs{end + 1} = 'V_{DS}';
            
            % V_GS
%             if self.numChannels == 4
%                 yyaxis left
%                 vgsOnLine = line(time, waveform.v_gs * vgsScaling);
%                 vgsOnLine.Color = vgsColor;
%                 vgsOnLine.LineWidth = lineWidth;
%                 legendStrs{end + 1} = ['V_{GS} \times ' num2str(vgsScaling)];
%             end
            
            % I_D
            yyaxis right
            ylabel('Current (A)')
            measSubP.YColor = 'black';
            idOnLine = line(time, waveform.i_d);
            idOnLine.Color = idColor;
            idOnLine.LineWidth = lineWidth;
            legendStrs{end + 1} = 'I_D';
            
%             % I_L
%             yyaxis right
%             ilOnLine = line(waveform.time, waveform.i_l);
%             ilOnLine.Color = ilColor;
%             ilOnLine.LineWidth = lineWidth;
%             legendStrs{end + 1} = 'I_L';
            
            plotLegend = legend(legendStrs);
            plotLegend.Orientation = 'horizontal';
            plotLegend.Location = 'southoutside';
        end

        function plotWaveformsScopeStyle(self, timeBoundsOn, timeBoundsOff)
            % Set Colors
            vdsColor = [0 0 1];
            vgsColor = [0 1 0];
            idColor = [1 0 0];
            vcompColor = [1 0 1];
            powerColor = [0 0 0];
            vdsScaling = 100;
            vcompScaling = 100;

            % Set other plot values
            lineWidth = 3;
            fontSize = 20;
            
            for waveformNumber=1:2
                if (waveformNumber == 1)
                    waveform = self.turnOnWaveform;
                    name = 'Turn On Waveform';
                    power = self.pOn;
                else
                    waveform = self.turnOffWaveform;
                    name = 'Turn Off Waveform';
                    power = self.pOff;
                end
            
                % Find VGS Scaling Factor
%                 if self.numChannels == 4
%                     vgsScaling = ceil(max(waveform.v_gs)) / ceil(max(waveform.v_ds)/vdsScaling);
%                     while (min(waveform.v_gs/vgsScaling) < -1)
%                         vgsScaling = vgsScaling + 1;
%                     end
%                 end
                idScaling = ceil((max(waveform.i_d)) / ceil(max(waveform.v_ds)/vdsScaling) / 5) * 5;
                if (idScaling < 5)
                    idScaling = ceil((max(waveform.i_d)) / ceil(max(waveform.v_ds)/vdsScaling));
                end
                pScaling = ceil(max(power)/5);
                if pScaling == 1
                    pScaling = ceil(max(power)/0.5);
                end
                if (waveformNumber == 1)
                    disp('Turn On Waveform Plot Scaling:');
                else
                    disp('Turn Off Waveform Plot Scaling:');
                end
                fprintf('Pon scale = %2.0f kW/div \n',pScaling/1e3);
                fprintf('vds scale = %2.0f V/div \n',vdsScaling);
%                 fprintf('vgs scale = %2.0f V/div \n',vgsScaling);
                fprintf('id scale  = %2.0f A/div \n\n',idScaling);
                % Change time to nS
                time = waveform.time * 1e9;
                timeUnits = 'ns';
                            
                % Plot Waveform
                switchFigure = figure();
                switchFigure.Name = name;
                switchFigure.NumberTitle = 'off';
%                 switchFigure.Units = 'inches';
                
                if (waveformNumber == 1)
                    if (nargin < 2 || ~isnumeric(timeBoundsOn))
                        timeBoundsOn = [0 time(end)];
                        timeIndices = [1:length(time)];
                    else
                        % Ensure timeBoundsOn does not exceed array dimensions
                        timeBoundsOn(1) = max(timeBoundsOn(1), time(1));
                        timeBoundsOn(2) = min(timeBoundsOn(2), time(end));

                        timeBoundsOn(2) = ceil((timeBoundsOn(2)-timeBoundsOn(1))/10)*10+timeBoundsOn(1);
                        timeIndices = [find(time>timeBoundsOn(1),1):find(time<=timeBoundsOn(2),1, 'last')];
                    end
                    screenSize = get(groot,'ScreenSize');
%                     switchFigure.Position = [1 2 7.4 4.5];
                    switchFigure.Position = [screenSize(4)*0.01 screenSize(4)*0.15 screenSize(3)*0.55 screenSize(4)*0.55];
                else
                    if (nargin < 3)
                        timeBoundsOff = [0 time(end)];
                        timeIndices = [1:length(time)];
                    else
                        % Ensure timeBoundsOff does not exceed array dimensions
                        timeBoundsOff(1) = max(timeBoundsOff(1), time(1));
                        timeBoundsOff(2) = min(timeBoundsOff(2), time(end));

                        timeBoundsOff(2) = ceil((timeBoundsOff(2)-timeBoundsOff(1))*10)/10+timeBoundsOff(1);
                        timeIndices = [find(time>timeBoundsOff(1),1):find(time<=timeBoundsOff(2),1, 'last')];
                    end
%                     switchFigure.Position = [9 2 7.4 4.5];
                    switchFigure.Position = [screenSize(3)*0.44 screenSize(4)*0.15 screenSize(3)*0.55 screenSize(4)*0.55];
                end
                time = time(timeIndices) - time(timeIndices(1));
                % Setup Figure

                % Setup Power Subplot
                powerSubPlot = subplot(2, 1, 1);
                powerSubPlot.XGrid = 'on';
                powerSubPlot.YGrid = 'on';
                powerSubPlot.Position = [0.01 0.77 0.98 0.22];
                powerSubPlot.XAxis.Visible = 'off';
                powerSubPlot.YAxis.Visible = 'off';
                powerSubPlot.FontSize = fontSize;
                powerSubPlot.YTick = [-100:1:100];
                powerSubPlot.GridLineStyle = '--';
                powerSubPlot.GridColor = [0.4 0.4 0.4];
                powerSubPlot.GridAlpha = 1;
%                 powerSubPlot.BoxStyle = 'full';
                line([0 time(end)],[0 0],'Color',[0.4 0.4 0.4],'LineStyle','-.','LineWidth',3);

                powerLine = line(powerSubPlot, time, power(timeIndices)/pScaling);
                powerLine.Color = powerColor;
                powerLine.LineWidth = lineWidth;

                powerYAxis = powerSubPlot.YAxis;
                powerYAxis.Limits = [floor(min(power/pScaling)) ceil(max(power/pScaling))];
                powerYAxisLength = powerYAxis.Limits(2)-powerYAxis.Limits(1);
                axis([0 time(end) powerYAxis.Limits]);
                                
                hold on;
                fill([0 0 time(end)/30], [-powerYAxisLength/8 powerYAxisLength/8 0],'black');
                line([0 0], [powerYAxis.Limits], 'color','black','linewidth',2)
                line([1 1]*time(end), [powerYAxis.Limits], 'color','black','linewidth',2)
                line([0 time(end)], [1 1]*powerYAxis.Limits(1), 'color','black','linewidth',2)
                line([0 time(end)], [1 1]*powerYAxis.Limits(2), 'color','black','linewidth',2)

                % Setup Measured subplot
                measSubP = subplot(2, 1, 2);
                measSubP.Position = [0.01 0.16 0.98 0.6];

                measSubP.XGrid = 'on';
                measSubP.YGrid = 'on';
                measSubP.GridLineStyle = '--';
                measSubP.GridColor = [0.6 0.6 0.6];
                measSubP.GridAlpha = 1;
                measSubP.FontSize = fontSize;
                measSubP.XAxis.Visible = 'on';
                measSubP.YAxis.Visible = 'off';
                measSubP.YTick = [-100:1:100];
                measYAxis = measSubP.YAxis;

                xlabel(['Time (' timeUnits ')']);
                line([0 time(end)],[0 0],'Color',[0.4 0.4 0.4],'LineStyle','-.','LineWidth',3);

                % V_DS
                vdsOnLine = line(time, waveform.v_ds(timeIndices) / vdsScaling);
                vdsOnLine.Color = vdsColor;
                vdsOnLine.LineWidth = lineWidth;

                % V_GS
%                 if self.numChannels == 4
%                     vgsOnLine = line(time, waveform.v_gs(timeIndices) / vgsScaling);
%                     vgsOnLine.Color = vgsColor;
%                     vgsOnLine.LineWidth = lineWidth;
%                 end

                % I_D
                idOnLine = line(time, waveform.i_d(timeIndices) / idScaling);
                idOnLine.Color = idColor;
                idOnLine.LineWidth = lineWidth;

                % Vcomp
                vcompOnLine = line(time, waveform.v_complementary(timeIndices) / vcompScaling);
                vcompOnLine.Color = vcompColor;
                vcompOnLine.LineWidth = lineWidth;

                axis([0 time(end) measYAxis.Limits]);
                measYAxisLength = measYAxis.Limits(2)-measYAxis.Limits(1);
                xTick = get(measSubP,'XTick');
                measSubP.XTick = xTick(1:end-1);
                hold on;
%                 if self.numChannels == 4
%                     fill([0 0 time(end)/30]+time(end)/50, [-1 1 0]*measYAxisLength/20, vgsColor);
%                 end
                fill([0 0 time(end)/30]+time(end)/50, [-1 1 0]*measYAxisLength/20, vcompColor);
                fill([0 0 time(end)/30]+time(end)/100, [-1 1 0]*measYAxisLength/20, idColor);
                fill([0 0 time(end)/30], [-1 1 0]*measYAxisLength/20, vdsColor);
                line([0 0], [measYAxis.Limits], 'color','black','linewidth',2)
                line([1 1]*time(end), [measYAxis.Limits], 'color','black','linewidth',2)
                line([0 time(end)], [1 1]*measYAxis.Limits(1), 'color','black','linewidth',2)
                line([0 time(end)], [1 1]*measYAxis.Limits(2), 'color','black','linewidth',2)
            end
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
            endIdx = self.turnOnWaveform.switchIdx - pointsInTime(5e-9);
            beforeSwitchID = self.turnOnWaveform.i_d(startIdx:endIdx);
            
            self.loadCurrent = mean(beforeSwitchID);
        end
        function calcCurrentTurnOnIdx(self)
            % Find Current Turn on idx
            % Point in I_D turn on waveform where current starts to 
            % increase and does not stop increasing
            self.currentTurnOnIdx = self.findOffIdx(self.turnOnWaveform.i_d);
        end
        function calcCurrentTurnOffIdx(self)
            % Find Current Turn Off idx
            % Point in I_D turn off waveform where current starts to
            % decrease and does not stop decreasing.
            self.currentTurnOffIdx = self.findOnIdx(self.turnOffWaveform.i_d);
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
            % Find V_DS turn off 10% and 90% off point
            offWF = self.turnOffWaveform.v_ds;
            % Device is 10% off when V_DS has risen from 0 to 10% of the 
            % Bus Voltage.
            oFF10Idx = find(offWF > .1 * self.busVoltage, 1);
            % Device is 90% off when V_DS has risen to 90% of the bus
            % voltage.
            off90Idx = find(offWF < .9 * self.busVoltage, 1, 'last');
            
            % Create vector from 10% on to 90% on
            offEdge = offWF(oFF10Idx:off90Idx);
            
            % find DV/DT 
            dv_dt = diff(offEdge) / self.turnOffWaveform.samplePeriod;
            
            % Max DV/DT 
            self.turnOffPeakDV_DT = max(abs(dv_dt));
        end
        function calcTurnOnEnergy(self)
            % Calculate the energy loss during turn on.
            % Find the power
            self.pOn = self.turnOnWaveform.v_ds .* self.turnOnWaveform.i_d;
            
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
            
            % Find point where current is zero
%             idAtZero = find(self.turnOffWaveform.i_d < 0, 1);

            % Find Current zero crossings
            signId = sign(self.turnOffWaveform.i_d);
            signDiff = diff(signId);
            zeroCrossings = find(signDiff < 0);

            % Find maximum V_DS point
            [~, maxVdsIdx] = max(self.turnOffWaveform.v_ds);
            
            % Take moving average of V_DS
            smoothVds = self.movingAvg(5, self.turnOffWaveform.v_ds);
            
            % Find V_DS Peaks
            [vdsPeaks, vdsPeakLocs] = findpeaks(smoothVds(smoothVds > self.busVoltage));
            
            % Check if max V_DS is before or after 3rd peak
            if maxVdsIdx > vdsPeakLocs(3)
                % Unstable, Use first zero crossing
                stopIdx = zeroCrossings(1);
            else
                % Use zero crossing after max
                stopIdx = zeroCrossings(find(zeroCrossings > maxVdsIdx, 1));
            end
            
            % find energy loss during switching
            eOffCum = cumtrapz(self.turnOffWaveform.time, self.pOff);
            
            eOff = eOffCum(stopIdx) - eOffCum(self.currentTurnOffIdx);
            
            % Set loss
            self.turnOffEnergy = eOff;
        end
        function calcPeakVDS(self)
            % Calculate maximum V_DS during turn on and turn off waveform
            self.turnOnPeakVDS = max(self.turnOnWaveform.v_ds);
            self.turnOffPeakVDS = max(self.turnOffWaveform.v_ds);
        end
        function calcOnIntegrals(self)
            % Calculate the turn on integral of VDS and ID
            startI = self.currentTurnOnIdx;
            stopI = self.v_ds_at0Idx;
            
            voltage = self.turnOnWaveform.v_ds(startI:stopI);
            current = self.turnOnWaveform.i_d(startI:stopI);
            time = self.turnOnWaveform.time(startI:stopI);
            
            self.turnOnVDSInt = trapz(time, voltage);
            self.turnOnIDInt = trapz(time, current);
            
        end
        function calcOffIntegrals(self)
            % Calculate the turn off integral of VDS and ID
            startI = self.currentTurnOffIdx;
            stopI = self.vDSatBus;
            
            voltage = self.turnOffWaveform.v_ds(startI:stopI);
            current = self.turnOffWaveform.i_d(startI:stopI);
            time = self.turnOffWaveform.time(startI:stopI);
            
            self.turnOffVDSInt = trapz(time, voltage);
            self.turnOffIDInt = trapz(time, current);
            
        end
    end
    methods (Access = public, Static)

        function nomValue = findNominalValue(waveform)
            %% Ensure waveform is a column vector
            if isrow(waveform)
                waveform = waveform';
            end
            
            %% find approximate switching point
            % Use mean value as an estimation for the halfway point
            midValue = mean(waveform);
            
            % find halfway point idx
            midIdx = dsearchn(waveform, midValue);
            
            %% Find initial and final average values
            meanLength = floor(midIdx / 2); 
            initValue = mean(waveform(1:midIdx - meanLength));
            finalValue = mean(waveform(end-meanLength:end));
            
            %% Nominal value is the maximum of the final and initial values.
            nomValue = max([initValue, finalValue]);
        end
        %% movingAvg: Takes a moving average of the input
        function [movingAvg] = movingAvg(avgPts, waveform)
            % Set filter weights to be equal + 1 includes current point
            filterW = ones(1, avgPts + 1) / (avgPts + 1);
            
            % Setup pads to prevent moving filter from shifting to zero
            startPad = ones(1, avgPts) * waveform(1);
            stopPad = ones(1, avgPts) * waveform(end);
            
            % Pad waveform
            waveform = [startPad waveform stopPad];
            movingAvg = filter(filterW, 1, waveform);
            movingAvg = movingAvg(avgPts + 1:end - (avgPts));
        end
    end
    methods (Access = protected, Static)
        function [onIdx] = findOnIdx(onWaveform)
            % Find nominal value
            nomValue = SyncDoublePulseResults.findNominalValue(onWaveform);

            % Start searching at 10% of the nominal value
            startValue = 0.5 * nomValue;
            
            % We must first check to ensure that the signal is not
            % excessively "ringy." We will do this by ensuring the the 
            
            
            startIdx = find(onWaveform > startValue, 1);

            % offIdx is point before startIdx where value starts to
            % decrease and does not stop. Use +- 5 sample moving average.
            movingAvg = SyncDoublePulseResults.movingAvg(10, onWaveform);

            onDiff = diff(movingAvg);

            onIdx = find(onDiff(1:startIdx) < 0, 1, 'last') + 1;
        end
        function [offIdx] = findOffIdx(offWaveform)
            % Find Nominal Value
            nomValue = SyncDoublePulseResults.findNominalValue(offWaveform);
            
            % Start searching at the 90% of nominal value
            startValue = 0.9 * nomValue;
            startIdx = find(offWaveform < startValue, 1);
            
            % offIdx is point before startIdx where value starts to
            % decrease and does not stop. Use +- 5 sample moving average.
            movingAvg = SyncDoublePulseResults.movingAvg(10, offWaveform);
            
            offDiff = diff(movingAvg);
            
            offIdx = find(offDiff(1:startIdx) > 0, 1, 'last') + 1;
        end
    end
    
    
end

function out = range(x)
    out = max(x) - min(x);
end

