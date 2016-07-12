function [ settings ] = SettingsSweepObject()
    dpt_settings = DPTSettings;

    % Double Pulse Test Settings
    %% Test Specific Settings
    dpt_settings.busVoltages = [100];
    dpt_settings.loadCurrents = [10];
    dpt_settings.currentResistor = 102E-3;
    dpt_settings.loadInductor = 720E-6;
    dpt_settings.minGateVoltage = -3;
    dpt_settings.maxGateVoltage = 10;
    dpt_settings.gateLogicVoltage = 5;

    %% Instrument Setup
        % Buffer Sizes
        dpt_settings.FGen_buffer_size = 6000000;
        dpt_settings.Scope_Buffer_size = 200000;

        % VISA Resource Strings
        dpt_settings.scopeVisaAddress = 'USB0::0x0699::0x0502::C051196::0::INSTR';
        dpt_settings.FGenVisaAddress = 'USB0::0x0957::0x2307::MY50000715::0::INSTR';

        % Set Vendor Strings
        dpt_settings.scopeVendor = 'tek';
        dpt_settings.FGenVendor = 'agilent';

        % Communication
        dpt_settings.scopeTimeout = 10;
        dpt_settings.scopeByteOrder = 'littleEndian';

    %% Channel Setup
        % Channel Numbers
        dpt_settings.channel.VDS = 1;
        dpt_settings.channel.VGS = 2;
        dpt_settings.channel.ID = 4;
        dpt_settings.channel.IL = 3; % Set to -1 if not measuring load current

    %% Pulse Creation
        dpt_settings.PeakValue = dpt_settings.gateLogicVoltage;
        dpt_settings.pulse_lead_dead_t = 1e-6;
        dpt_settings.pulse_off_t = 5e-6;
        dpt_settings.pulse_second_pulse_t = 5e-6;
        dpt_settings.pulse_end_dead_t = 1e-6;
        
        % Mini Second Pulse
        dpt_settings.use_mini_2nd_pulse = true;
        dpt_settings.mini_2nd_pulse_off_time = 50e-9;

        % Burst Settings
        dpt_settings.burstMode = 'TRIGgered';
        dpt_settings.FGenTriggerSource = 'BUS';
        dpt_settings.burstCycles = 1;

     %% Pulse Measurement
        dpt_settings.scopeSampleRate = 10E9;
        dpt_settings.scopeRecordLength = 2000000;
        dpt_settings.useAutoRecordLength = true;
        dpt_settings.autoRecordLengthBuffer = 1.5;

        % Waveform
        dpt_settings.numBytes = 1;
        dpt_settings.encoding = 'SRI';
        dpt_settings.numVerticalDivisions = 10;

        % Probe Gains
        dpt_settings.chProbeGain = [1, 1, 1, 1];
        dpt_settings.invertCurrent = true;

        % Initial Vertical Settings
        dpt_settings.chInitialOffset = [0, 0, 0, 0];
        dpt_settings.chInitialScale = [0, 0, 0, 0];
        dpt_settings.chInitialPosition = [0, 0, 0, 0];
        dpt_settings.chInitialPosition(dpt_settings.VDS_Channel) = -(floor(dpt_settings.numVerticalDivisions / 2) - 1);
        dpt_settings.maxCurrentSpike = 100;
        dpt_settings.percentBuffer = 10;
        
        % Deskew Settings
        dpt_settings.deskewVoltage = min(dpt_settings.busVoltages);
        dpt_settings.deskewCurrent = max(dpt_settings.loadCurrents);
        dpt_settings.VGSDeskew = 4e-9;
        % VDS Vertical Settings
        dpt_settings.chInitialScale(dpt_settings.VDS_Channel) = dpt_settings.deskewVoltage * 2 / (dpt_settings.numVerticalDivisions - 1);
        dpt_settings.chInitialPosition(dpt_settings.VDS_Channel) = -(dpt_settings.numVerticalDivisions / 2 - 1);
        % VGS Vertical Settings
        [dpt_settings.chInitialScale(dpt_settings.VGS_Channel),...
            dpt_settings.chInitialPosition(dpt_settings.VGS_Channel)] = min2Scale(...
            dpt_settings.minGateVoltage, dpt_settings.maxGateVoltage,...
            dpt_settings.numVerticalDivisions, 50);
        % ID Vertical Settings
        dpt_settings.chInitialScale(dpt_settings.ID_Channel) = dpt_settings.maxCurrentSpike * 2 / (dpt_settings.numVerticalDivisions / 2 - 1);
        dpt_settings.chInitialPosition(dpt_settings.ID_Channel) = 0;
        
        
        % Initial Horizontal Settings
        dpt_settings.horizontalScale = 50e-6;
        dpt_settings.delayMode = 'Off';
        dpt_settings.horizontalPosition = 25;

        % Trigger 
        dpt_settings.triggerType = 'EDGe';
        dpt_settings.triggerCoupling = 'DC';
        dpt_settings.triggerSlope = 'FALL';
        dpt_settings.triggerSource = dpt_settings.VDS_Channel;
        dpt_settings.triggerLevel = min(dpt_settings.busVoltages) / 2;

        % Acquisition
        dpt_settings.acquisitionMode = 'SAMple';
        dpt_settings.acquisitionSamplingMode = 'RT';
        dpt_settings.acquisitionStop = 'SEQuence';

    %% Data Saving
        % Data Directory
        dpt_settings.dataDirectory = 'Measurements\testing\';
    %% Data Processing
        % Turn on Window
        dpt_settings.window.turn_on_prequel = 30e-9;
        dpt_settings.window.turn_on_time = 80e-9;
        
        % Turn off Window
        dpt_settings.window.turn_off_prequel = dpt_settings.window.turn_on_prequel;
        dpt_settings.window.turn_off_time = dpt_settings.window.turn_on_time;
       
    settings = dpt_settings;
end