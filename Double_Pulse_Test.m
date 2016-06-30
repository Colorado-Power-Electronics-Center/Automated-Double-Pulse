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
    
    setVoltageToLoad(myScope, loadVoltage, settings);
    
    % Swtich to triggering on V_GS for IV misalignment pulses
    deskew_settings = copy(settings);
    deskew_settings.triggerSource = deskew_settings.VGS_Channel;
    deskew_settings.triggerLevel = deskew_settings.maxGateVoltage / 2;
    deskew_settings.triggerSlope = 'RISe';
    
    [ waveForms ] = runDoublePulseTest(myScope, myFGen,...
                loadCurrent, loadVoltage, deskew_settings);
    [ turn_on_waveforms ] = extractWaveforms('turn_on',...
        waveForms, loadVoltage, settings);
    [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, 4, turn_on_waveforms, settings);
            
    [ ~, ~, ~, turn_on_voltage, ~, turn_on_current, turn_on_time ] = ...
        extract_turn_on_waveform( loadVoltage, V_DS, V_GS, I_D, time );
    % Find Deskew
    settings.currentDelay = -findDeskew(turn_on_voltage, turn_on_current, turn_on_time);   

    % Obtain Measurements
    for loadVoltage = settings.loadVoltages    
        % set Voltage (user or auto)
        setVoltageToLoad(myScope, loadVoltage, settings);
        for loadCurrent = settings.loadCurrents
            % Capture Zoomed Out Waveform
            % VDS Vertical Settings
            settings.chInitialScale(settings.VDS_Channel) = loadVoltage * 2 / (settings.numVerticalDivisions - 1);
            settings.chInitialPosition(settings.VDS_Channel) = -(settings.numVerticalDivisions / 2 - 1);
            % ID Vertical Settings
            settings.chInitialScale(settings.ID_Channel) = settings.maxCurrentSpike * 2 / (settings.numVerticalDivisions / 2 - 1);
            settings.chInitialPosition(settings.ID_Channel) = 0;
            
            % Run Zoomed out pulse
            [ zoomedOutWaveforms ] = runDoublePulseTest( myScope, myFGen,...
                loadCurrent, loadVoltage, settings );
            for testChannel = [4, 2]
                for switch_capture = {'turn_on', 'turn_off'}
                    % Get correct waveforms
                    scalingWaveform = extractWaveforms(switch_capture{1}, zoomedOutWaveforms, loadVoltage, settings);
                    
                    [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, testChannel , scalingWaveform, settings); %#ok<ASGLU>
                    sampleRate = myScope.sampleRate; %#ok<NASGU>
                    file_name = [settings.dataDirectory num2str(loadVoltage)...
                        'V_' num2str(loadCurrent) 'A_' switch_capture{1} '_' num2str(testChannel) 'CH.mat'];
                    save(file_name, 'V_DS', 'V_GS', 'I_D', 'time', 'sampleRate',...
                        'loadCurrent', 'loadVoltage', 'switch_capture');
                end
            end
        end
    end

    % Disconnect from instruments
    myScope.disconnect;
    myFGen.disconnect;

    % Process Measurements
    %% Find Deskew
end

function [ returnWaveforms ] = runDoublePulseTest( myScope, myFGen,...
    loadCurrent, loadVoltage, settings )
%runDoublePulseTest Summary of this function goes here
%   Detailed explanation goes here
    %%% Unpack Settings %%%
    loadInductor = settings.loadInductor;
    currentResistor = settings.currentResistor;
    
    %% Channel Setup
    % Channel Numbers
    VDS_Channel = settings.VDS_Channel;
    VGS_Channel = settings.VGS_Channel;
    ID_Channel = settings.ID_Channel;
    IL_Channel = settings.IL_Channel;
    
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
    acquisitionSamplingMode = settings.acquisitionSamplingMode;
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
    if ~settings.use_mini_2nd_pulse
        [ch2_wave_points, ~] = pulse_generator(sampleRate,...
            pulse_lead_dead_t + pulse_first_pulse_t + .1 * pulse_off_t,...
            .8 * pulse_off_t,...
            .1 * pulse_off_t + pulse_second_pulse_t + pulse_end_dead_t);
    else
        second_pulse_off_t = settings.mini_2nd_pulse_off_time;
        [ch2_wave_points, ~] = pulse_generator(sampleRate,...
            0, pulse_lead_dead_t + pulse_first_pulse_t + pulse_off_t + 17e-9,...
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
    
    % Set Channel Label Names
    myScope.setChLabelName(VDS_Channel, 'V_DS');
    myScope.setChLabelName(VGS_Channel, 'V_GS');
    myScope.setChLabelName(ID_Channel, 'I_D');
    myScope.setChLabelName(IL_Channel, 'I_L');
    
    % Turn Off Headers
    myScope.removeHeaders;

    % Set Scope Dependent Properties
    if myScope.scopeSeries == SCPI_Oscilloscope.Series5000
        % Set Horizontal Axis to maunal mode
        myScope.horizontalMode = 'MANual';
        
        % Set Load Current Channel Attenuation
        myScope.setChExtAtten(settings.ID_Channel, 1/settings.currentResistor);
        myScope.setChExtAttenUnits(settings.ID_Channel, 'A'); 
    else
        % Set Data Resolution to Full
        myScope.dataResolution = 'FULL';
    end

    % Set scope sample rate and record length
    myScope.sampleRate = scopeSampleRate;
    if settings.useAutoRecordLength
        myScope.recordLength = total_time * myScope.sampleRate...
            * settings.autoRecordLengthBuffer;
    else
        myScope.recordLength = scopeRecordLength;
    end

    % Setup Probe Gains of neccessary
    if myScope.scopeSeries == SCPI_Oscilloscope.Series4000
        for channel = 1:4
            myScope.setChProbeGain(channel, chProbeGain(channel));
        end
    else
        % todo
    end

    % Set Oscilloscope Deskew
    myScope.setChDeskew(settings.ID_Channel, settings.currentDelay);
    myScope.setChDeskew(settings.VGS_Channel, settings.VGSDeskew);
    
    % Set Scope Channel Termination
    myScope.setChTermination(settings.ID_Channel, 50);
    
    % Set Initial Vertical Settings
    for channel = 1:4
        myScope.setChOffSet(channel, chInitialOffset(channel));
        myScope.setChScale(channel, chInitialScale(channel));
        myScope.setChPosition(channel, chInitialPosition(channel));
    end
    
    % Set I_L Scaling to the same as I_D
    if settings.IL_Channel > 0
        myScope.setChScale(settings.IL_Channel, myScope.getChScale(settings.ID_Channel));
        myScope.setChPosition(settings.IL_Channel, myScope.getChPosition(settings.ID_Channel));
    end
    
    % Invert Current Channel
    if settings.invertCurrent
        if myScope.scopeSeries ~= SCPI_Oscilloscope.Series5000
            myScope.setChInvert(ID_Channel, 'ON');
        else
            warning('5000 Series Scopes do not support inverting');
            myScope.setChInvert(ID_Channel, 'OFF');
        end
    else
        myScope.setChInvert(ID_Channel, 'OFF');
    end
    
    % Set Current Probe Range
    if IL_Channel > 0
        myScope.setChProbeControl(IL_Channel, 'MANual');
        myScope.setChProbeForcedRange(IL_Channel, 30);
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
    myScope.acqSamplingMode = acquisitionSamplingMode;
    myScope.acqStopAfter = acquisitionStop;
    myScope.acqState = 'RUN';

    pause(2);

    % Trigger Waveform
    myFGen.push2Trigger('pulse');

    % Setup binary data for the CURVE query
    myScope.setupWaveformTransfer(numBytes, encoding);
    
    pause(1);

    % Check if trigger recieved
    if myScope.acqState ~= 0
        error('Trigger not detected');
    end
    
    % Get all four waveforms
    WaveForms = cell(1, 4);

    for idx = myScope.enabledChannels
        WaveForms{idx} = myScope.getWaveform(idx);
    end
    
    % Create time vector
    WaveForms{waveformTimeIdx} = (0:myScope.recordLength - 1) / myScope.sampleRate;
    
    % Return Waveforms
    returnWaveforms = WaveForms;
end

function [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, numChannels, waveforms, settings)
    % Rescale Oscilloscope VDS, VGS, and ID Channels
    for channel = [settings.VDS_Channel settings.VGS_Channel settings.ID_Channel]
        myScope.rescaleChannel(channel, waveforms{channel},...
            settings.numVerticalDivisions, settings.percentBuffer);
    end
    
    % Rescale Oscilloscope IL Channel
    if settings.IL_Channel > 0
        myScope.setChScale(settings.IL_Channel, myScope.getChScale(settings.ID_Channel));
        myScope.setChPosition(settings.IL_Channel, myScope.getChPosition(settings.ID_Channel));
    end
    
    % Ensure Channels are all on
    myScope.allChannelsOn;
    
    % Turn Off I_L and V_GS is 2 Channel measurement
    if numChannels == 2
        myScope.channelsOff([settings.IL_Channel settings.VGS_Channel]);
    end
    
    % Set Samplerate and record Length
    total_time = myFGen.numQuery('SOURce1:BURSt:INTernal:PERiod?');
    myScope.sampleRate = settings.scopeSampleRate;
    if settings.useAutoRecordLength
        myScope.recordLength = total_time * myScope.sampleRate...
            * settings.autoRecordLengthBuffer;
    else
        myScope.recordLength = scopeRecordLength;
    end

    % Rerun Capture
    myScope.acqState = 'RUN';

    pause(1);

    % Trigger Waveform
    myFGen.push2Trigger('pulse');

    pause(2);
    
    % Check if trigger recieved
    if myScope.acqState ~= 0
        error('Trigger not detected');
    end

    % Get Desired waveforms
    V_DS = myScope.getWaveform(settings.VDS_Channel);
    I_D = myScope.getWaveform(settings.ID_Channel) * -1;
    
    if numChannels == 4
        V_GS = myScope.getWaveform(settings.VGS_Channel);
    else
        V_GS = settings.notRecorded;
    end
    
    % Create time vector
    time = (0:myScope.recordLength - 1) / myScope.sampleRate;
end

function [ returnWaveforms ] = extractWaveforms(switch_capture, unExtractedWaveforms, loadVoltage, settings)
    [ turn_on_waveforms, turn_off_waveforms, ~, ~, ~, ~, ~ ]...
    = splitWaveforms( loadVoltage, unExtractedWaveforms, unExtractedWaveforms{waveformTimeIdx}, settings);

    if strcmp(switch_capture, 'turn_on')
        % Extract Turn on
        returnWaveforms = turn_on_waveforms;
    else
        % Extract turn off
        returnWaveforms = turn_off_waveforms;
    end
end

function setVoltageToLoad(myScope, loadVoltage, settings)
    myScope.channelsOn(settings.VDS_Channel);
    myScope.minMaxRescaleChannel(settings.VDS_Channel, 0, loadVoltage,...
        settings.numVerticalDivisions, settings.percentBuffer);
    myScope.acqState = 'ON';
    disp(['Set voltage to ' num2str(loadVoltage) 'V and press any key...'])
    pause;
end

function checkLoadInductor(myScope, myFGen, settings)
    % Determine Load Voltage and Current
    loadVoltage = min(settings.loadVoltages);
    loadCurrent = min(settings.loadCurrents);
    % Set Load Voltage
    setVoltageToLoad(myScope, loadVoltage, settings);
    
    % Set Scaling Information
    curChkSettings = copy(settings);
    % VDS Vertical Settings
    curChkSettings.chInitialScale(curChkSettings.VDS_Channel) = loadVoltage * 2 / (curChkSettings.numVerticalDivisions - 1);
    curChkSettings.chInitialPosition(curChkSettings.VDS_Channel) = -(curChkSettings.numVerticalDivisions / 2 - 1);
    % VGS Vertical Settings
    [curChkSettings.chInitialScale(curChkSettings.VGS_Channel),...
        curChkSettings.chInitialPosition(curChkSettings.VGS_Channel)] = min2Scale(...
        curChkSettings.minGateVoltage, curChkSettings.maxGateVoltage,...
        curChkSettings.numVerticalDivisions, 50);
    % ID Vertical Settings
    curChkSettings.chInitialScale(curChkSettings.ID_Channel) = loadCurrent * 2 / (curChkSettings.numVerticalDivisions / 2 - 1);
    curChkSettings.chInitialPosition(curChkSettings.ID_Channel) = 0;
    % Run Double Pulse
    [ zoomedOutWaveforms ] = runDoublePulseTest( myScope, myFGen,...
                loadCurrent, loadVoltage, curChkSettings );
    % Get correct waveforms
    scalingWaveforms = extractWaveforms('turn_off', zoomedOutWaveforms, loadVoltage, curChkSettings);

    [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, 4 , scalingWaveforms, curChkSettings);
    % Find Load Voltage
    % Split Waveforms
    fullWaveforms = cell(1, 5);
    fullWaveforms{curChkSettings.VDS_Channel} = V_DS;
    fullWaveforms{curChkSettings.VGS_Channel} = V_GS;
    fullWaveforms{curChkSettings.ID_Channel} = I_D;
    fullWaveforms{curChkSettings.IL_Channel} = settings.notRecorded;
    fullWaveforms{waveformTimeIdx} = time;
    
    offWaveforms = extractWaveforms('turn_off', fullWaveforms, loadVoltage, curChkSettings);
    
    % Find approximate switching idx
    off_I_D = offWaveforms{curChkSettings.ID_Channel};
    [~, switch_idx] = max(abs(diff(off_I_D)));
    % Real load current is average of current 10ns before swtich to 5ns
    % before swtich
    time_step = time(2) - time(1);
    numPoints_5ns = floor(5e-9 / time_step);
    realLoadCurrent = mean(off_I_D(switch_idx - 2 * numPoints_5ns:switch_idx - numPoints_5ns));
    % Calculate Error
    percentError = (realLoadCurrent - loadCurrent) / loadCurrent * 100;
    
    disp(['Error = ' num2str(percentError) '%']);
    
    % Find Actual Inductior value
    realInductor = settings.loadInductor * (1 + (percentError / 100));
    disp(['Real Inductor value = ' num2str(realInductor) 'H']);
end

function timeIdx = waveformTimeIdx
    timeIdx = 5;
end

function [scale, position] = min2Scale(minValue, maxValue, numDivisions, percentBuffer)
    data_range = maxValue - minValue;
    scale = (data_range / numDivisions);
    position = (minValue/scale) + (numDivisions / 2);
    scale = scale * (1 + percentBuffer / 100);
    position = position * (1 - percentBuffer / 100);
end