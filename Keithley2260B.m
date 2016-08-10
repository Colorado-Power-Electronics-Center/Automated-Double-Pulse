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
