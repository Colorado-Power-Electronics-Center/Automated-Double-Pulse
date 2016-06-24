classdef DPTSettings < handle
    %DPTSettings Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Double Pulse Test Settings
		%% Test Specific Settings
		loadVoltages
		loadCurrents
		currentResistor
		loadInductor
		gateVoltage

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
	    
		%% Pulse Creation
	    PeakValue
	    pulse_lead_dead_t
	    pulse_off_t
	    pulse_second_pulse_t
	    pulse_end_dead_t

	    % Burst Settings
	    burstMode
	    FGenTriggerSource
	    burstCycles
	    
	 	%% Pulse Measurement
	    scopeSampleRate
	    scopeRecordLength
	    
	    % Waveform
	    numBytes
	    encoding
	    numVerticalDivisions

	    % Probe Gains
	    chProbeGain

	    % Initial Vertical Settings
	    chInitialOffset
	    chInitialScale
	    chInitialPosition

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

