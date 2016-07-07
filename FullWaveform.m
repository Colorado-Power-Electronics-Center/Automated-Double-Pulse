classdef FullWaveform < GeneralWaveform & handle
    %FullWaveform Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aproxBusVoltage
        
        turn_on_idx
        turn_off_idx
        
        turnOnWaveform@SwitchWaveform
        turnOffWaveform@SwitchWaveform
        
        windowSize@WindowSize
    end
    
    methods (Access = private)
        function extractSwitches(self)
            %% Find switching indicies using V_DS curve
            % Round V_DS Curve to on or off
            V_DS_Round = round(self.v_ds / self.aproxBusVoltage) * ...
                self.aproxBusVoltage;
            
            % Find switching indicies
            V_DS_Round_Diff = diff(V_DS_Round);
            switching_idx = find(V_DS_Round_Diff ~= 0);
            
            %% Remove Switches that occour within 50 ns of the previous
            % Calculate Number of points in 50 ns
            num_points = floor(50e-9 * self.sampleRate);
            % Find and remove switches that occour within num_points of the
            % previous.
            switching_idx_diff = diff(switching_idx);
            false_switch_idxs = logical([0 (switching_idx_diff < num_points)]);
            switching_idx(false_switch_idxs) = [];
            
            %% Check if first switch is on or off
            % and define turn on and turn off indexs
            if V_DS_Round_Diff(switching_idx(1)) > 0
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
                stopIdx = startIdx + self.windowSize.turn_off_time_idxs;
            else
                % Turn Off Wavefrom
                prequelIdx = self.windowSize.turn_off_prequel_idxs;
                startIdx = self.turn_off_idx - prequelIdx;
                stopIdx = startIdx + self.windowSize.turn_off_time_idxs;
            end
            
            % Create Switch Waveform
            sectionedWF = SwitchWaveform;
            sectionedWF.switchCapture = switchCapture;
            sectionedWF.channel = copy(self.channel);
            sectionedWF.switchIdx = prequelIdx;
            
            % Set Waveform Values
            sectionedWF.v_ds = self.v_ds(startIdx:stopIdx);
            sectionedWF.i_d = self.i_d(startIdx:stopIdx);
            if self.v_gs ~= GeneralWaveform.NOT_RECORDED;
                sectionedWF.v_gs = self.v_gs(startIdx:stopIdx);
            else
                sectionedWF.v_gs = self.v_gs;
            end
            if self.i_l ~= GeneralWaveform.NOT_RECORDED;
                sectionedWF.i_l = self.i_l(startIdx:stopIdx);
            else
                sectionedWF.i_l = self.i_l;
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
            fullCapture.aproxBusVoltage = busVoltage;
            fullCapture.extractSwitches;
            
            FW = fullCapture;
        end
    end
    
end

