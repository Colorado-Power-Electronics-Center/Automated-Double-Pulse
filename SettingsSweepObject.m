function [ settings ] = SettingsSweepObject()
    dpt_settings = DPTSettings;

    % Double Pulse Test Settings
    %% Test Specific Settings
    dpt_settings.loadVoltages = [1, 2];
    dpt_settings.loadCurrents = [.1, 1];
    dpt_settings.currentResistor = 3E-3;
    dpt_settings.loadInductor = 500E-6;
    dpt_settings.gateVoltage = 10;
    dpt_settings.gateLogicVoltage = 5;

    %% Instrument Setup
        % Buffer Sizes
        dpt_settings.FGen_buffer_size = 6000000;
        dpt_settings.Scope_Buffer_size = 200000;

        % VISA Resource Strings
        dpt_settings.scopeVisaAddress = 'USB::0x0699::0x03A4::C030239::INSTR';
        dpt_settings.FGenVisaAddress = 'USB::0x0957::0x2C07::MY52812846::INSTR';

        % Set Vendor Strings
        dpt_settings.scopeVendor = 'tek';
        dpt_settings.FGenVendor = 'agilent';

        % Communication
        dpt_settings.scopeTimeout = 10;
        dpt_settings.scopeByteOrder = 'littleEndian';

    %% Channel Setup
        % Channel Numbers
        dpt_settings.VDS_Channel = 1;
        dpt_settings.VGS_Channel = 2;
        dpt_settings.ID_Channel = 3;
        dpt_settings.IL_Channel = 4; % Set to -1 if not measuring load current

    %% Pulse Creation
        dpt_settings.PeakValue = dpt_settings.gateLogicVoltage;
        dpt_settings.pulse_lead_dead_t = 1e-6;
        dpt_settings.pulse_off_t = 5e-6;
        dpt_settings.pulse_second_pulse_t = 5e-6;
        dpt_settings.pulse_end_dead_t = 1e-6;
        
        % Mini Second Pulse
        dpt_settings.use_mini_2nd_pulse = true;
        dpt_settings.mini_2nd_pulse_off_time = 20e-9;

        % Burst Settings
        dpt_settings.burstMode = 'TRIGgered';
        dpt_settings.FGenTriggerSource = 'BUS';
        dpt_settings.burstCycles = 1;

     %% Pulse Measurement
        dpt_settings.scopeSampleRate = 1E9;
        dpt_settings.scopeRecordLength = 1000000;

        % Waveform
        dpt_settings.numBytes = 1;
        dpt_settings.encoding = 'SRI';
        dpt_settings.numVerticalDivisions = 8;

        % Probe Gains
        dpt_settings.chProbeGain = [1, 1, 1, 1];
        dpt_settings.invertCurrent = true;

        % Initial Vertical Settings
        dpt_settings.chInitialOffset = [0, 0, 0, 0];
        dpt_settings.chInitialScale = [0, 0, 0, 0];
        dpt_settings.chInitialPosition = ones(1, 4) * -(dpt_settings.numVerticalDivisions - 1);
        dpt_settings.chInitialPosition(dpt_settings.ID_Channel) = 0;
        dpt_settings.chInitialPosition(dpt_settings.IL_Channel) = 0;
        dpt_settings.maxCurrentSpike = 100;
        dpt_settings.percentBuffer = 10;
        
        % Initial Horizontal Settings
        dpt_settings.horizontalScale = 50e-6;
        dpt_settings.delayMode = 'Off';
        dpt_settings.horizontalPosition = 25;

        % Trigger 
        dpt_settings.triggerType = 'EDGe';
        dpt_settings.triggerCoupling = 'DC';
        dpt_settings.triggerSlope = 'FALL';
        dpt_settings.triggerSource = dpt_settings.VDS_Channel;
        dpt_settings.triggerLevel = min(dpt_settings.loadVoltages) / 2;

        % Aquisition
        dpt_settings.acquisitionMode = 'SAMple';
        dpt_settings.acquisitionStop = 'SEQuence';

    %% Data Saving
        % Data Directory
        dpt_settings.dataDirectory = 'Measurements\testing\';
    %% Data Processing
        % Turn on Window
        dpt_settings.turn_on_prequel = 15e-9;
        dpt_settings.turn_on_time = 80e-9;
        dpt_settings.turn_on_prequel_idxs = ...
            floor(dpt_settings.turn_on_prequel * dpt_settings.scopeSampleRate);
        dpt_settings.turn_on_time_idxs = ...
            floor(dpt_settings.turn_on_time * dpt_settings.scopeSampleRate);
        
        % Turn off Window
        dpt_settings.turn_off_prequel = dpt_settings.turn_on_prequel;
        dpt_settings.turn_off_time = dpt_settings.turn_on_time;
        dpt_settings.turn_off_prequel_idxs = ...
            floor(dpt_settings.turn_off_prequel * dpt_settings.scopeSampleRate);
        dpt_settings.turn_off_time_idxs = ...
            floor(dpt_settings.turn_off_time * dpt_settings.scopeSampleRate);
       
    settings = dpt_settings;
end