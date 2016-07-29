function checkLoadInductor(myScope, myFGen, settings)
    error('checkLoadInductor is currently outdated and incompatible with the rest of the code.')

    % Determine Bus Voltage and Load Current
    busVoltage = min(settings.busVoltages);
    loadCurrent = min(settings.loadCurrents);
    % Set Bus Voltage
    setVoltageToLoad(myScope, busVoltage, settings);
    
    % Set Scaling Information
    curChkSettings = copy(settings);
    % VDS Vertical Settings
    curChkSettings.chInitialScale(curChkSettings.VDS_Channel) = busVoltage * 2 / (curChkSettings.numVerticalDivisions - 1);
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
                loadCurrent, busVoltage, curChkSettings );
    % Get correct waveforms
    scalingWaveforms = extractWaveforms('turn_off', zoomedOutWaveforms, busVoltage, curChkSettings);

    [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, 4 , scalingWaveforms, curChkSettings);
    % Find Bus Voltage
    % Split Waveforms
    fullWaveforms = cell(1, 5);
    fullWaveforms{curChkSettings.VDS_Channel} = V_DS;
    fullWaveforms{curChkSettings.VGS_Channel} = V_GS;
    fullWaveforms{curChkSettings.ID_Channel} = I_D;
    fullWaveforms{curChkSettings.IL_Channel} = settings.notRecorded;
    fullWaveforms{waveformTimeIdx} = time;
    
    offWaveforms = extractWaveforms('turn_off', fullWaveforms, busVoltage, curChkSettings);
    
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