classdef DPTSettings < matlab.mixin.Copyable
    %DPTSettings Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        notRecorded = -102;
    end
    
    properties
        % Double Pulse Test Settings
		%% Test Specific Settings
		loadVoltages
		loadCurrents
		currentResistor
		loadInductor
		minGateVoltage
        maxGateVoltage
        gateLogicVoltage

		%% Instrument Setup
	    % Buffer Sizes
	    FGen_buffer_size
	    Scope_Buffer_size

	    % VISA Resource Strings
	    scopeVisaAddress
	    FGenVisaAddress

	    % Set Vendor Strings
	    scopeVendor
	    FGenVendor

	    % Communication
	    scopeTimeout
	    scopeByteOrder

		%% Channel Setup
	    % Channel Numbers
	    VDS_Channel
	    VGS_Channel
	    ID_Channel
        IL_Channel
	    
		%% Pulse Creation
	    PeakValue
	    pulse_lead_dead_t
	    pulse_off_t
	    pulse_second_pulse_t
	    pulse_end_dead_t
        
        % Mini Second Pulse (For Edwards Test Setup)
        use_mini_2nd_pulse
        mini_2nd_pulse_off_time

	    % Burst Settings
	    burstMode
	    FGenTriggerSource
	    burstCycles
	    
	 	%% Pulse Measurement
	    scopeSampleRate
	    scopeRecordLength
        useAutoRecordLength
        autoRecordLengthBuffer
	    
	    % Waveform
	    numBytes
	    encoding
	    numVerticalDivisions

	    % Probe Gains
	    chProbeGain
        invertCurrent

	    % Initial Vertical Settings
	    chInitialOffset
	    chInitialScale
	    chInitialPosition
        maxCurrentSpike
        percentBuffer
        
        % Deskew Settings
        deskewVoltage
        deskewCurrent
        currentDelay
        VGSDeskew

	    % Initial Horizontal Settings
	    horizontalScale
	    delayMode
	    horizontalPosition

	    % Trigger 
	    triggerType
	    triggerCoupling
	    triggerSlope
	    triggerSource
	    triggerLevel

	    % Aquisition
	    acquisitionMode
        acquisitionSamplingMode
	    acquisitionStop
	    
		%% Data Saving
	    % Data Directory
	    dataDirectory
        
        %% Data Processing
        % Turn on Window
        turn_on_prequel
        turn_on_time
        turn_on_prequel_idxs
        turn_on_time_idxs
        
        % Turn off Window
        turn_off_prequel
        turn_off_time
        turn_off_prequel_idxs
        turn_off_time_idxs
        
    end
    
    methods
    end
    
end

