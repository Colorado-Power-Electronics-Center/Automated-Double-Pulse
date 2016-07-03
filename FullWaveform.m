classdef FullWaveform < GeneralWaveform & handle
    %FullWaveform Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aproxBusVoltage
        
        turn_on_idx
        turn_off_idx
        
        turnOnWaveform
        turnOffWaveform
    end
    
    methods (Access = private)
        function extractSwitches(self)
            %
        end
    end
    
    methods (Static)
        function FW = fromChannelCell(waveforms, channels, busVoltage)
            % Create General Version of class
            fullCapture = GeneralWaveform.fromChannelCell(FullWaveform,...
                waveforms, channels);
            
            % Assign Bus Voltage and extract Switches
            fullCapture.aproxBusVoltage = busVoltage;
            fullCapture.extractSwitches;
            
            FW = fullCapture;
        end
    end
    
end

