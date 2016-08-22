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