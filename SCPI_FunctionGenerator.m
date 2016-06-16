classdef SCPI_FunctionGenerator < SCPI_Instrument & handle
    %SCPI_FunctionGenerator Sub-Class of SCPI_Instrument for use with
    %Function Generators.
    %   Currently the class works with Keysight / Agilent Function
    %   generators, but it can be modified to work with other scopes either
    %   by modifying the methods here or by creating another level of
    %   subclass (either beneath this class or SCPI_Instrument) that works
    %   with other brands of function generators. 
    
    properties
    end
    
    methods
        function self = SCPI_FunctionGenerator(visaVendor, visaAddress)
            self@SCPI_Instrument(visaVendor, visaAddress);
        end
        function loadArbWaveform(self, wave_points, sample_rate, PeakValue, name, channel)
            % loadArbWaveform loads arbitrary waveform onto Function
            % Generator
            %   Args: (wave_points, sample_rate, PeakValue, name, channel)
            %   wave_points: Vector of datapoints in the wave
            %   sample_rate: Rate at which data points should be read
            %   PeakValue: Maximum height of waveform (bottom is always 0)
            %   name: String title of waveform (max 12 Characters)
            %   channel: Function Generator Channel to load waveform, on can
            %   be string or number.
            
            % Convert Matrix into CSV String
            strData = sprintf('%d, ', wave_points);
            strData = strData(1:end-2);
            
            if isnumeric(channel)
                channel = int2str(channel);
            end
            
            % Set FG Arbitrary waveform settings
            self.sendCommand(['SOURce' channel ':FUNCtion ARB']);
            self.setArbSampleRate(channel, sample_rate);
            self.sendCommand(['SOURce' channel ':FUNC:ARB:FILTER STEP']);
            self.sendCommand(['SOURce' channel ':FUNC:ARB:PTPEAK ' num2str(PeakValue)]);
            
            % Load Waveform
            self.sendCommand(['SOURce' channel ':DATA:ARB ' name ', ' strData]);
            self.sendCommand(['SOURce' channel ':FUNC:ARB ' name]);
        end
        function setupBurst(self, mode, nCycles, period, source, channel)
            % setupBurst sets Function Generator Burst Settings
            %   Args: (mode, nCycles, period, source, channel)
            %   mode: Burst mode {TRIGgered|GATed}
            %   nCycles: Number of times to send burst
            %   period: Total length of each cycle
            %   source: Source of burst Trigger
            %   {IMMediate|EXTernal|TIMer|BUS}
            %   channel: Function Generator channel to setup Burst for
            
            if isnumeric(channel)
                channel = int2str(channel);
            end
            
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
            % Acceptable values for rate
            % {<sample_rate>|MINimum|MAXimum|DEFault}
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

