classdef DPTSettings < matlab.mixin.Copyable
    %DPTSettings Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        notRecorded = GeneralWaveform.NOT_RECORDED;
    end
    
    properties (Dependent)
        % Channel Numbers
	    VDS_Channel
	    VGS_Channel
	    ID_Channel
        IL_Channel
    end
    
    properties
        % Double Pulse Test Settings
		%% Test Specific Settings
		busVoltages
		loadCurrents
		currentResistor
		loadInductor
		minGateVoltage = 0;
        maxGateVoltage
        gateLogicVoltage

		%% Instrument Setup
	    % Buffer Sizes
	    FGen_buffer_size = 6000000;
	    Scope_Buffer_size = 200000;
        Bus_Supply_buffer_size = 200000;

	    % VISA Resource Strings
	    scopeVisaAddress
	    FGenVisaAddress
	    BusSupplyVisaAddress

	    % Set Vendor Strings
	    scopeVendor = 'tek';
	    FGenVendor = 'agilent';
	    BusSupplyVendor = 'agilent';

	    % Communication
	    scopeTimeout = 10;
	    scopeByteOrder = 'littleEndian';

		%% Channel Setup
        % Channel Numbers
        channel@channelMapper
	    
		%% Pulse Creation
	    pulse_lead_dead_t = 1e-6;
	    pulse_off_t = 5e-6;
	    pulse_second_pulse_t = 5e-6;
	    pulse_end_dead_t = 1e-6;
        
        % Mini Second Pulse (For Edwards Test Setup)
        use_mini_2nd_pulse = false;
        mini_2nd_pulse_off_time = 50e-9;

	    % Burst Settings
	    burstMode = 'TRIGgered';
	    FGenTriggerSource = 'BUS';
	    burstCycles = 1;
	    
	 	%% Pulse Measurement
	    scopeSampleRate = 10E9;
	    scopeRecordLength = 2000000;
        useAutoRecordLength = true;
        autoRecordLengthBuffer = 1.1;
	    
	    % Waveform
	    numBytes = 1;
	    encoding = 'SRI';
	    numVerticalDivisions = 10;

	    % Probe Gains
	    chProbeGain = [1, 1, 1, 1];
        invertCurrent = true;

	    % Initial Vertical Settings
	    chInitialOffset = [0, 0, 0, 0];
	    chInitialScale = [0, 0, 0, 0];
	    chInitialPosition = [0, 0, 0, 0];
        maxCurrentSpike = 100;
        percentBuffer = 10;
        
        % Deskew Settings
        deskewVoltage = NaN;
        deskewCurrent = NaN;
        currentDelay
        VGSDeskew = 0;

	    % Initial Horizontal Settings
	    horizontalScale = 50e-6;
	    delayMode = 'OFF';
	    horizontalPosition = 5;

	    % Trigger 
	    triggerType = 'EDGe';
	    triggerCoupling = 'DC';
	    triggerSlope = 'FALL';
	    triggerSlopeDeskew = 'RISe'
	    triggerSource = NaN;
	    triggerSourceDeskew = NaN;
	    triggerLevel = NaN;
	    triggerLevelDeskew = NaN;

	    % Acquisition
	    acquisitionMode = 'SAMple';
        acquisitionSamplingMode = 'RT';
	    acquisitionStop = 'SEQuence';
	    
		%% Data Saving
	    % Data Directory
	    dataDirectory = 'Measurements\'
        
        %% Data Processing
        window@WindowSize
        
        %% Automation Level Settings
        push2pulse = false
        autoBusControl = false
        busSlewRate = 100;
        
    end
    
    methods
        % Constructor
        function self = DPTSettings()
            self.channel = channelMapper;
            self.window = WindowSize;
        end

        % Calculate Scale for channel
        function calcScale(self, channel, minValue, maxValue, percentBuffer)
        	[newScale, newPos] = min2Scale(minValue, maxValue,...
            self.numVerticalDivisions, percentBuffer);
	        self.chInitialScale(channel) = newScale;
	        self.chInitialPosition(channel) = newPos;
        end
        
        function calcDefaultScales(self)
            % VDS Vertical Settings (This value will only be used for the initial deskew pulse)
            self.calcScale(self.VDS_Channel, 0, self.deskewVoltage, 100)
            
            % VGS Vertical Settings (This value will be used for all initial pulses)
            self.calcScale(self.VGS_Channel, self.minGateVoltage,...
                           self.maxGateVoltage, 50)
                               
            % ID Vertical Settings (This value will be used for all initial pulses)
            self.calcScale(self.ID_Channel, -self.maxCurrentSpike,...
                           max([self.maxCurrentSpike,...
                           self.loadCurrents]), 100)
        end                  
        
        % Methods to allow for backwards compatibility with old channel
        % storage functionality.
        function out = get.VDS_Channel(self)
            out = self.channel.VDS;
        end
        function out = get.VGS_Channel(self)
            out = self.channel.VGS;
        end
        function out = get.ID_Channel(self)
            out = self.channel.ID;
        end
        function out = get.IL_Channel(self)
            out = self.channel.IL;
        end

        % Functions for returning default values if values not assigned
		function trigChan = get.triggerSource(self)
        	trigChan = self.defaultIfNaN(self.triggerSource, self.channel.VDS);
        end
		function trigChan = get.triggerSourceDeskew(self)
	    	trigChan = self.defaultIfNaN(self.triggerSourceDeskew, self.channel.VGS);
	    end

	    function trigLevel = get.triggerLevel(self)
	    	trigLevel = self.defaultIfNaN(self.triggerLevel, min(self.busVoltages) / 2);
	    end
	    function trigLevel = get.triggerLevelDeskew(self)
	    	trigLevel = self.defaultIfNaN(self.triggerLevelDeskew, self.maxGateVoltage / 2);
	    end

	    function out = get.deskewVoltage(self)
	    	out = self.defaultIfNaN(self.deskewVoltage, min(self.busVoltages));
	    end
		function out = get.deskewCurrent(self)
			out = self.defaultIfNaN(self.deskewCurrent, max(self.loadCurrents));
		end
    end

    methods (Access = private, Static)
    	function out = defaultIfNaN(curVal, default)
    		if isnan(curVal)
    			out = default;
    		else
    			out = curVal;
    		end
    	end
    end
    
    methods (Static)
        % doc
        function doc()
            showdemo DPTSettings
        end
    end
    
end

