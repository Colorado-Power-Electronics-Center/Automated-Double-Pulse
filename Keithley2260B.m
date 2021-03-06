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

classdef Keithley2260B < SCPI_VoltageSource & handle
    %Keithley2260B Sub-Class of SCPI_VoltageSource that will
    %control the Keithley 2260B voltage source. 

    properties

	end

	methods
		% Super Overrides
		function self = Keithley2260B(visaVendor, visaAddress)
			self@SCPI_VoltageSource(visaVendor, visaAddress);

			self.outVoltageCmd = 'VOLTage';
            self.outCurrentCmd = 'CURRent';
			self.outputStateCmd = 'OUTPut';
			self.outputModeCmd = 'OUTPut:MODE';
			self.voltageSlewFallingCmd = 'VOLTage:SLEW:RISing';
			self.voltageSlewRisingCmd = 'VOLTage:SLEW:FALLing';
		end

		%% Control Methods
		function initSupply(self)
			self.outputState = 'OFF';
			self.outVoltage = 0;
			self.outputMode = 'CVLS';
			self.outputState = 'ON';
            self.outCurrent = 0.25;
			self.initialized = true;
		end
		function setSlewedVoltage(self, outVoltage, slewRate)
            % Function sets power supplies voltage to outVoltage at a rate
            % of slewRate V/s

            % Ensure that voltage supply is initialized
            if self.initialized == false
                error('Voltage Source not initialized.');
            end
            
            startVoltage = self.outVoltage;
            time = abs(startVoltage - outVoltage) / slewRate;

            self.voltageSlewRising = slewRate;
            self.voltageSlewFalling = slewRate; 

            self.outVoltage = outVoltage;

            pause(time)
        end

	end
end
