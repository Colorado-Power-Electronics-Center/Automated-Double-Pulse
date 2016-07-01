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
    busVoltage = min(settings.busVoltages);
    
    setVoltageToLoad(myScope, busVoltage, settings);
    
    % Swtich to triggering on V_GS for IV misalignment pulses
    deskew_settings = copy(settings);
    deskew_settings.triggerSource = deskew_settings.VGS_Channel;
    deskew_settings.triggerLevel = deskew_settings.maxGateVoltage / 2;
    deskew_settings.triggerSlope = 'RISe';
    
    [ waveForms ] = runDoublePulseTest(myScope, myFGen,...
                loadCurrent, busVoltage, deskew_settings);
    [ turn_on_waveforms ] = extractWaveforms('turn_on',...
        waveForms, busVoltage, settings);
    [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, 4, turn_on_waveforms, settings);
            
    [ ~, ~, ~, turn_on_voltage, ~, turn_on_current, turn_on_time ] = ...
        extract_turn_on_waveform( busVoltage, V_DS, V_GS, I_D, time );
    % Find Deskew
    settings.currentDelay = findDeskew(turn_on_voltage, turn_on_current, turn_on_time);   

    % Obtain Measurements
    for busVoltage = settings.busVoltages    
        % set Voltage (user or auto)
        setVoltageToLoad(myScope, busVoltage, settings);
        for loadCurrent = settings.loadCurrents
            % Capture Zoomed Out Waveform
            % VDS Vertical Settings
            settings.chInitialScale(settings.VDS_Channel) = busVoltage * 2 / (settings.numVerticalDivisions - 1);
            settings.chInitialPosition(settings.VDS_Channel) = -(settings.numVerticalDivisions / 2 - 1);
            % ID Vertical Settings
            settings.chInitialScale(settings.ID_Channel) = settings.maxCurrentSpike * 2 / (settings.numVerticalDivisions / 2 - 1);
            settings.chInitialPosition(settings.ID_Channel) = 0;
            
            % Run Zoomed out pulse
            [ zoomedOutWaveforms ] = runDoublePulseTest( myScope, myFGen,...
                loadCurrent, busVoltage, settings );
            for testChannel = [4, 2]
                for switch_capture = {'turn_on', 'turn_off'}
                    % Get correct waveforms
                    scalingWaveform = extractWaveforms(switch_capture{1}, zoomedOutWaveforms, busVoltage, settings);
                    
                    [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, testChannel , scalingWaveform, settings); %#ok<ASGLU>
                    sampleRate = myScope.sampleRate; %#ok<NASGU>
                    file_name = [settings.dataDirectory num2str(busVoltage)...
                        'V_' num2str(loadCurrent) 'A_' switch_capture{1} '_' num2str(testChannel) 'CH.mat'];
                    save(file_name, 'V_DS', 'V_GS', 'I_D', 'time', 'sampleRate',...
                        'loadCurrent', 'busVoltage', 'switch_capture');
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