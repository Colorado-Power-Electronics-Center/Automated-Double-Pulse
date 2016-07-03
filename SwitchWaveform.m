classdef SwitchWaveform < GeneralWaveform & handle
    %SwitchWaveform Class containing the switch waveforms from a double
    %pulse test.
    
    properties (Constant)
        TURN_ON = 'turn_on';
        TURN_OFF = 'turn_off';
    end
    
    properties
        switchCapture
    end
    methods
        function self = SwitchWaveform(v_ds, v_gs, i_d, i_l, time,...
                                            switchCapture)
            if nargin == 0
                superArgs = {};
            else
                superArgs = {v_ds, v_gs, i_d, i_l, time};
            end
            
            self@GeneralWaveform(superArgs{:});
            
            if nargin > 0
                self.switchCapture = switchCapture;
            end
        end
    end
    
    
    
end

