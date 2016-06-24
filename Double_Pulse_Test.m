function Double_Pulse_Test(settings)
    % Create Copy of Settings File in data Folder
    if ~exist(settings.dataDirectory, 'dir')
        mkdir(settings.dataDirectory);
    end
    save([settings.dataDirectory 'Measurement_Settings.mat'], 'settings');

    %% Setup
    % Clear Matlab Workspace of any previous instrument connections
    instrreset;

    % Setup Oscilloscope
    myScope = SCPI_Oscilloscope(settings.scopeVendor, settings.scopeVisaAddress);
    myScope.visaObj.InputBufferSize = settings.Scope_Buffer_size;
    myScope.visaObj.Timeout = settings.scopeTimeout;
    myScope.visaObj.ByteOrder = settings.scopeByteOrder;

    % Setup Function Generator
    myFGen = SCPI_FunctionGenerator(settings.FGenVendor, settings.FGenVisaAddress);
    myFGen.visaObj.InputBufferSize = settings.FGen_buffer_size;
    myFGen.visaObj.OutputBufferSize = settings.FGen_buffer_size;

    % Connect to devices
    myScope.connect;
    myFGen.connect;

    % Reset to default state
    myScope.reset;
    myScope.clearStatus;
    myFGen.reset;
    myFGen.clearStatus;

    % Find Deskew using lowest load settings
    loadCurrent = min(settings.loadCurrents);
    loadVoltage = min(settings.loadVoltages);
    [ V_DS, V_GS, I_D ] = runDoublePulseTest(myScope, myFGen,...
                loadCurrent, loadVoltage, settings);
    time = (0:(numel(V_DS) - 1)) / myScope.sampleRate;
    [ ~, ~, ~, turn_on_voltage, ~, turn_on_current, turn_on_time ] = ...
        extract_turn_on_waveform( loadVoltage, V_DS, V_GS, I_D, time );
    % Find Deskew
    current_delay = findDeskew(turn_on_voltage, turn_on_current, turn_on_time);

    % Set Oscilloscope Deskew
    myScope.setChDeskew(settings.ID_Channel, -current_delay);   

    % Obtain Measurements
    for loadVoltage = settings.loadVoltages    
        % set Voltage (user or auto)
        disp(['Set voltage to ' num2str(loadVoltage) 'V and press any key...'])
        pause;
        for loadCurrent = settings.loadCurrents
            [ V_DS, V_GS, I_D ] = runDoublePulseTest(myScope, myFGen,...
                loadCurrent, loadVoltage, settings);

            file_name = [settings.dataDirectory num2str(loadVoltage) 'V-' num2str(loadCurrent) 'A.mat'];
            save(file_name, 'V_DS', 'V_GS', 'I_D',...
                'loadCurrent', 'loadVoltage');
        end
    end

    % Disconnect from instruments
    myScope.disconnect;
    myFGen.disconnect;

    % Process Measurements
    %% Find Deskew
end

function [ V_DS, V_GS, I_D ] = runDoublePulseTest( myScope, myFGen,...
    loadCurrent, loadVoltage, settings )
%runDoublePulseTest Summary of this function goes here
%   Detailed explanation goes here
    %%% Unpack Settings %%%
    loadInductor = settings.loadInductor;
    currentResistor = settings.currentResistor;
    gateVoltage = settings.gateVoltage;
    
    %% Channel Setup
    % Channel Numbers
    VDS_Channel = settings.VDS_Channel;
    VGS_Channel = settings.VGS_Channel;
    ID_Channel = settings.ID_Channel;
    
    %% Pulse Creation
    PeakValue = settings.PeakValue;
    pulse_lead_dead_t = settings.pulse_lead_dead_t;
    pulse_off_t = settings.pulse_off_t;
    pulse_second_pulse_t = settings.pulse_second_pulse_t;
    pulse_end_dead_t = settings.pulse_end_dead_t;

    % Burst Settings
    burstMode = settings.burstMode;
    FGenTriggerSource = settings.FGenTriggerSource;
    burstCycles = settings.burstCycles;
    
    %% Pulse Measurement
    scopeSampleRate = settings.scopeSampleRate;
    scopeRecordLength = settings.scopeRecordLength;
    
    % Waveform
    numBytes = settings.numBytes;
    encoding = settings.encoding;
    numVerticalDivisions = settings.numVerticalDivisions;

    % Probe Gains
    chProbeGain = settings.chProbeGain;

    % Initial Vertical Settings
    chInitialOffset = settings.chInitialOffset;
    chInitialScale = settings.chInitialScale;
    chInitialPosition = settings.chInitialPosition;

    % Initial Horizontal Settings
    horizontalScale = settings.horizontalScale;
    delayMode = settings.delayMode;
    horizontalPosition = settings.horizontalPosition;

    % Trigger 
    triggerType = settings.triggerType;
    triggerCoupling = settings.triggerCoupling;
    triggerSlope = settings.triggerSlope;
    triggerSource = settings.triggerSource;
    triggerLevel = settings.triggerLevel;

    % Aquisition
    acquisitionMode = settings.acquisitionMode;
    acquisitionStop = settings.acquisitionStop;
    
    % Reset to default state
    myScope.reset;
    myScope.clearStatus;
    myFGen.reset;
    myFGen.clearStatus;

    %% Pulse Creation
    % Find Function Generator Maximum Sample Rate
    sampleRate = myFGen.getArbSampleRate(1, 'MAXimum');

    % Setup CH1 Waveform
    % Calculate first pulse duration
    pulse_first_pulse_t = loadInductor * (loadCurrent / loadVoltage);

    % Generate Double Pulse
    [ch1_wave_points, total_time] = pulse_generator(sampleRate,... 
        pulse_lead_dead_t, pulse_first_pulse_t, pulse_off_t,... 
        pulse_second_pulse_t, pulse_end_dead_t);

    % Load Waveform
    myFGen.loadArbWaveform(ch1_wave_points, sampleRate, PeakValue, 'double_pulse', 1);

    % Setup Burst
    myFGen.setupBurst(burstMode, burstCycles, total_time, FGenTriggerSource, 1);

    % Set Load
    myFGen.setOutputLoad(1, 'INFinity');

    % Setup CH2 Waveform
    % Generate Single Pulse
    if false
        [ch2_wave_points, total_time] = pulse_generator(sampleRate,...
            pulse_lead_dead_t + pulse_first_pulse_t + .1 * pulse_off_t,...
            .8 * pulse_off_t,...
            .1 * pulse_off_t + pulse_second_pulse_t + pulse_end_dead_t);
    else
        second_pulse_off_t = 20e-9;
        [ch2_wave_points, total_time] = pulse_generator(sampleRate,...
            0, pulse_lead_dead_t + pulse_first_pulse_t + pulse_off_t,...
            second_pulse_off_t, pulse_second_pulse_t);
    end

    % Load Waveform
    myFGen.loadArbWaveform(ch2_wave_points, sampleRate, PeakValue, 'single_pulse', 2);

    % Setup Burst
    myFGen.setupBurst(burstMode, burstCycles, total_time, FGenTriggerSource, 2);

    % Set Load
    myFGen.setOutputLoad(2, 'INFinity');

    %% Pulse Measurement
    % Ensure all Channels on
    myScope.allChannelsOn;

    % Turn Off Headers
    myScope.removeHeaders;

    % Set Scope Depended Properties
    if myScope.scopeSeries == SCPI_Oscilloscope.Series5000
        % Set Horizontal Axis to maunal mode
        myScope.horizontalMode = 'MANual';
    else
        % Set Data Resolution to Full
        myScope.dataResolution = 'FULL';
    end

    % Set scope sample rate and record length
    myScope.sampleRate = scopeSampleRate;
    myScope.recordLength = scopeRecordLength;

    % Setup Probe Gains of neccessary
    if myScope.scopeSeries == SCPI_Oscilloscope.Series4000
        for channel = 1:4
            myScope.setChProbeGain(channel, chProbeGain(channel));
        end
    else
        % todo
    end

    % Set Initial Vertical Axis
    chInitialScale(VDS_Channel) = loadVoltage * 2 / (numVerticalDivisions - 1); 
    chInitialScale(VGS_Channel) = gateVoltage * 2 / (numVerticalDivisions - 1); 
    chInitialScale(ID_Channel) = (loadCurrent * currentResistor) * 2 / (numVerticalDivisions - 1); 
    for channel = 1:4
        myScope.setChOffSet(channel, chInitialOffset(channel));
        myScope.setChScale(channel, chInitialScale(channel));
        myScope.setChPosition(channel, chInitialPosition(channel));
    end

    % Set Initial Horizontal Axis
    myScope.horizontalScale = horizontalScale;
    myScope.horizontalDelayMode = delayMode;
    myScope.horizontalPosition = horizontalPosition;

    % Setup Trigger
    myScope.setupTrigger(triggerType, triggerCoupling, triggerSlope,...
        triggerSource, triggerLevel);

    % Setup Acquisition
    myScope.acqMode = acquisitionMode;
    myScope.acqStopAfter = acquisitionStop;
    myScope.acqState = 'RUN';

    pause(1);

    % Trigger Waveform
    myFGen.trigger;

    % Setup binary data for the CURVE query
    myScope.setupWaveformTransfer(numBytes, encoding);

    % Get all four waveforms
    WaveForms = cell(1, 4);

    for idx = 1:4
        WaveForms{idx} = myScope.getWaveform(idx);
    end

    % Rescale Oscilloscope
    for idx = 1:4
        myScope.rescaleChannel(idx, WaveForms{idx}, numVerticalDivisions);
    end

    % Rerun Capture
    myScope.acqState = 'RUN';

    pause(1);

    % Trigger Waveform
    myFGen.trigger;

    pause(1);

    % Get all four waveforms
    WaveForms = cell(1, 4);

    for idx = 1:4
        WaveForms{idx} = myScope.getWaveform(idx);
    end

    % Save Waveforms
    V_DS = WaveForms{VDS_Channel};
    V_GS = WaveForms{VGS_Channel};
    I_D = WaveForms{ID_Channel} / currentResistor;

end