classdef SCPI_FunctionGenerator < SCPI_Instrument & handle
    %SCPI_FunctionGenerator Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function self = SCPI_FunctionGenerator(visaVendor, visaAddress)
            self@SCPI_Instrument(visaVendor, visaAddress);
        end
        function loadArbWaveform(self, wave_points, sample_rate, PeakValue, name, channel)
            strData = sprintf('%d, ', wave_points);
            strData = strData(1:end-2);
            
            channel = int2str(channel);

            self.sendCommand(['SOURce' channel ':FUNCtion ARB']);
            self.setArbSampleRate(channel, sample_rate);
            self.sendCommand(['SOURce' channel ':FUNC:ARB:FILTER STEP']);
            self.sendCommand(['SOURce' channel ':FUNC:ARB:PTPEAK ' num2str(PeakValue)]);
            
            self.sendCommand(['SOURce' channel ':DATA:ARB ' name ', ' strData]);
            self.sendCommand(['SOURce' channel ':FUNC:ARB ' name]);
        end
        function setupBurst(self, mode, nCycles, period, source, channel)
            channel = int2str(channel);
            self.sendCommand(['SOURce' channel ':BURSt:MODE ' mode]);
            self.sendCommand(['SOURce' channel ':BURSt:NCYCles ' int2str(nCycles)]);
            self.sendCommand(['SOURce' channel ':BURSt:INTernal:PERiod ' num2str(period)]);
            self.sendCommand(['TRIGger' channel ':SOURce ' source]);
            self.sendCommand(['SOURce' channel ':BURSt:STATe ON']);
            self.sendCommand(['OUTPut' channel ' ON']);
        end
        function setOutputLoad(self, channel, load)
            % Acceptable values for load
            % {<ohms>|INFinity|MINimum|MAXimum|DEFault}
            if isnumeric(channel)
                channel = int2str(channel);
            end
            if isnumeric(load)
               load = num2str(load);
            end
           
            self.sendCommand(['OUTPut' channel ':LOAD ' load]);
        end
        function load = getOutputLoad(self, channel, modifier)
            % Acceptable values for modifier
            % {MINimum|MAXimum}
            if isnumeric(channel)
                channel = int2str(channel);
            end
            
            if nargin <= 2
                modifier = '';
            end
            
            load = self.numQuery(['OUTPut' channel ':LOAD? ' modifier]);
        end
        function setArbSampleRate(self, channel, rate)
            if isnumeric(channel)
                channel = int2str(channel);
            end
            if isnumeric(rate)
               rate = num2str(rate);
            end
           
            self.sendCommand(['SOURce' channel ':FUNC:ARB:SRATE ' rate]);
        end
        function load = getArbSampleRate(self, channel, modifier)
            % Acceptable values for modifier
            % {MINimum|MAXimum}
            if isnumeric(channel)
                channel = int2str(channel);
            end
            
            if nargin <= 2
                modifier = '';
            end
            
            load = self.numQuery(['SOURce' channel ':FUNC:ARB:SRATE? ' modifier]);
        end
        
    end
    
end

