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

classdef SorensonVoltageSource < SCPI_VoltageSource & handle
    %SorensonVoltageSource Sub-Class of SCPI_VoltageSource that will
    %control the Sorenson XG Series voltage sources. 
    
    properties
        
    end
    
    methods
        % Super Overrides
        function self = SorensonVoltageSource(visaVendor, visaAddress)
            self@SCPI_VoltageSource(visaVendor, visaAddress);
            
            self.outVoltageCmd = 'SOURce:VOLTage:LEVel:IMMediate:AMPLitude';
            self.outputStateCmd = 'OUTPut';
        end
        
        %% Control Methods
        function initSupply(self)
            % Set Output to 0 and Turn On
            self.outVoltage = 0;
            self.outputState = 'ON';
            self.initialized = true;
        end
        function setSlewedVoltage(self, outVoltage, slewRate)
            % Function sets power supplies voltage to outVoltage at a rate
            % of slewRate V/s
            
            % Ensure that voltage supply is initialized
            if self.initialized == false
                error('Voltage Source not initialized.');
            end
            
            % Set Sample Rate
            % Use 10 points per second / 1 point every 100 ms
            samplePeriod = 100e-3; % s
            samplePerS = 1 / samplePeriod;
            
            % Calculate Length of transition
            curVoltage = self.outVoltage;
            deltaV = outVoltage - curVoltage;
            deltaT = deltaV / slewRate;
            
            % Calculate total number of steps, rounding up
            numSteps = ceil(samplePerS * deltaT);
            
            % Calculate Steps
            VSteps = linspace(curVoltage, outVoltage, numSteps);
            
            % Remove Command Delay
            self.commandDelay = 0;
            
            % Raise Voltage
            for step = VSteps
                tic
                self.outVoltage = step;
                pause(samplePeriod - toc)
            end
        end
    end
end