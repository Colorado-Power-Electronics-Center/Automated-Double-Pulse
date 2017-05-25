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

classdef SwitchWaveform < GeneralWaveform & handle
    %SwitchWaveform Class containing the switch waveforms from a double
    %pulse test.
    
    properties (Constant)
        TURN_ON = 'turn_on';
        TURN_OFF = 'turn_off';
    end
    
    properties
        switchCapture
        switchIdx
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
        function out = isTurnOn(self)
            out = strcmp(self.switchCapture, SwitchWaveform.TURN_ON);
        end
    end
end

