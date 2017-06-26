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

classdef FullWaveform < GeneralWaveform & handle
    %FullWaveform Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        turn_on_idx
        turn_off_idx
        
        turnOnWaveform@SwitchWaveform
        turnOffWaveform@SwitchWaveform
        
        windowSize@WindowSize
    end
    
    methods (Access = private)
        function extractSwitches(self)
            %% Find switching indices using V_DS curve
            % Round V_DS Curve to on or off
            V_DS_Round = round(self.v_ds / self.approxBusVoltage) * ...
                self.approxBusVoltage;
            
            % Find switching indices
            V_DS_Round_Diff = diff(V_DS_Round);
            switching_idx = find(V_DS_Round_Diff ~= 0);
            
            %% Remove Switches that occur within 50 ns of the previous
            % Calculate Number of points in 50 ns
            num_points = floor(50e-9 * self.sampleRate);
            % Find and remove switches that occur within num_points of the
            % previous.
            switching_idx_diff = diff(switching_idx);
            false_switch_idxs = logical([0 (switching_idx_diff < num_points)]);
            switching_idx(false_switch_idxs) = [];
            
            %% Check if first switch is on or off
            % and define turn on and turn off indices
            if V_DS_Round_Diff(switching_idx(1)) > 0 && self.i_d(end) < 1 %Temporary trick to correctly trigger synchronous switch events
                % Turn off
                self.turn_off_idx = switching_idx(1);
                self.turn_on_idx = switching_idx(2);
            else
                % Turn on
                self.turn_off_idx = switching_idx(2);
                self.turn_on_idx = switching_idx(3);
            end
            
            % Extract turn on Waveform
            self.turnOnWaveform = self.sectionWaveform(SwitchWaveform.TURN_ON);
            
            % Extract turn off Waveform
            self.turnOffWaveform = self.sectionWaveform(SwitchWaveform.TURN_OFF);
        end
        function sectionedWF = sectionWaveform(self, switchCapture)
            % Find turn start and stop idxs
            if strcmp(switchCapture, SwitchWaveform.TURN_ON)
                % Turn On Waveform
                prequelIdx = self.windowSize.turn_on_prequel_idxs;
                startIdx = self.turn_on_idx - prequelIdx;
                stopIdx = startIdx + self.windowSize.turn_on_time_idxs;
            else
                % Turn Off Waveform
                prequelIdx = self.windowSize.turn_off_prequel_idxs;
                startIdx = self.turn_off_idx - prequelIdx;
                stopIdx = startIdx + self.windowSize.turn_off_time_idxs;
            end
            
            % Create Switch Waveform
            sectionedWF = SwitchWaveform;
            sectionedWF.switchCapture = switchCapture;
            sectionedWF.channel = copy(self.channel);
            sectionedWF.approxBusVoltage = self.approxBusVoltage;
            sectionedWF.switchIdx = prequelIdx;
            
            % Set Waveform Values
            sectionedWF.v_ds = self.v_ds(startIdx:stopIdx);
            sectionedWF.i_d = self.i_d(startIdx:stopIdx);
            if self.v_gs ~= GeneralWaveform.NOT_RECORDED;
                sectionedWF.v_gs = self.v_gs(startIdx:stopIdx);
            else
                sectionedWF.v_gs = self.v_gs;
            end
            if ~all(self.i_l == GeneralWaveform.NOT_RECORDED);
                sectionedWF.i_l = self.i_l(startIdx:stopIdx);
            else
                sectionedWF.i_l = self.i_l;
            end
            if ~all(self.v_complementary == GeneralWaveform.NOT_RECORDED);
                sectionedWF.v_complementary = self.v_complementary(startIdx:stopIdx);
            else
                sectionedWF.v_complementary = self.v_complementary;
            end
            sectionedWF.time = self.time(startIdx:stopIdx) - self.time(startIdx);
        end
    end
    
    methods (Static)
        function FW = fromChannelCell(waveforms, channels, busVoltage,...
                windowSize)
            % Create General Version of class
            fullCapture = GeneralWaveform.fromChannelCell(FullWaveform,...
                waveforms, channels);
            
            % Set Window Size
            fullCapture.windowSize = copy(windowSize);
            fullCapture.windowSize.sampleRate = fullCapture.sampleRate;
            
            % Assign Bus Voltage and extract Switches
            fullCapture.approxBusVoltage = busVoltage;
            fullCapture.extractSwitches;
            
            FW = fullCapture;
        end
    end
    
end

