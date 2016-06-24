%% Settings
    % Setup
        % Buffer Sizes
        FGen_buffer_size = 6000000;
        Scope_Buffer_size = 200000;
        
        % VISA Resource Strings
        scopeVisaAddress = 'USB::0x0699::0x03A4::C030239::INSTR';
        FGenVisaAddress = 'USB::0x0957::0x2C07::MY52812846::INSTR';
        
        % Set Vendor Strings
        scopeVendor = 'tek';
        FGenVendor = 'agilent';
        
        % Communication
        scopeTimeout = 10;
        scopeByteOrder = 'littleEndian';
    
    % Pulse Creation
        PeakValue = 1;
        pulse_lead_dead_t = 10e-6;
        pulse_first_pulse_t = 30e-6;
        pulse_off_t = 15e-6;
        pulse_second_pulse_t = 10e-6;
        pulse_end_dead_t = 10e-6;

        % Burst Settings
        burstMode = 'TRIGgered';
        FGenTriggerSource = 'BUS';
        burstCycles = 1;
    
    % Pulse Measurement
        scopeSampleRate = 1E9;
        scopeRecordLength = 1000000;
        
        % Probe Gains
        chProbeGain = [1, 1, 1, 1];
        
        % Initial Vertical Settings
        chInitialOffset = [0, 0, 0, 0];
        chInitialScale = [.3, .3, .3, .3];
        chInitialPosition = [-3, -3, -3, -3];
        
        % Initial Horizontal Settings
        horizontalScale = 20e-6;
        delayMode = 'Off';
        horizontalPosition = 25;

        % Trigger 
        triggerType = 'EDGe';
        triggerCoupling = 'DC';
        triggerSlope = 'RISe';
        triggerSource = 1;
        triggerLevel = 0.5;

        % Aquisition
        acquisitionMode = 'SAMple';
        acquisitionStop = 'SEQuence';
        
        % Waveform
        numBytes = 1;
        encoding = 'SRI';
        numVerticalDivisions = 8;