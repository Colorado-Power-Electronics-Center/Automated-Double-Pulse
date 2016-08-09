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
    
    % Setup Bus Voltage Supply
    myBusSupply = Keithley2260B(settings.BusSupplyVendor, settings.BusSupplyVisaAddress);
    myBusSupply.visaObj.InputBufferSize = settings.Bus_Supply_buffer_size;
    myBusSupply.visaObj.InputBufferSize = settings.Bus_Supply_buffer_size;
    myBusSupply.Timeout = 10;
    
    % Define Cleanup Function
    finishup = onCleanup(@() cleanupDPT(myScope, myFGen, myBusSupply));

    % Connect to devices
    myScope.connect;
    myFGen.connect;
    myBusSupply.connect;

    % Reset to default state
    myScope.reset;
    myScope.clearStatus;
    myFGen.reset;
    myFGen.clearStatus;
    
    % Initialize Bus Supply
    myBusSupply.initSupply;

    % Find Deskew using lowest load settings
    loadCurrent = settings.deskewCurrent;
    busVoltage = settings.deskewVoltage;
    
    setVoltageToLoad(myScope, myBusSupply, busVoltage, settings);
    
    % Switch to triggering on V_GS for IV misalignment pulses
    deskew_settings = copy(settings);
    deskew_settings.triggerSource = deskew_settings.triggerSourceDeskew;
    deskew_settings.triggerLevel = deskew_settings.triggerLevelDeskew;
    deskew_settings.triggerSlope = deskew_settings.triggerSlopeDeskew;
    
    [ fullWaveforms ] = runDoublePulseTest(myScope, myFGen,...
                loadCurrent, busVoltage, deskew_settings);
    [ rescaledFullWaveform ] = rescaleAndRepulse(myScope, myFGen, 4, fullWaveforms, settings);
            
    % Find Deskew
    settings.currentDelay = DoublePulseResults.findIVMisalignment(rescaledFullWaveform);
    disp(['IV Misalignment: ' num2str(settings.currentDelay)]);
    
    % Create Sweep results Object
    sweepResults = SweepResults;
    
    % Obtain Measurements
    for busVoltage = settings.busVoltages    
        % set Voltage (user or auto)
        setVoltageToLoad(myScope, myBusSupply, busVoltage, settings);
        for loadCurrent = settings.loadCurrents
            % Capture Zoomed Out Waveform
            % Change VDS Vertical Settings to account for new bus voltage
            settings.calcScale(settings.VDS_Channel, 0, busVoltage, 100);
            
            % Run Zoomed out pulse
            [ zoomedOutWaveforms ] = runDoublePulseTest( myScope, myFGen,...
                loadCurrent, busVoltage, settings );
            for testChannel = [4, 2]
                onWaveform = [];
                offWaveform = [];
                for scalingWaveform = [zoomedOutWaveforms.turnOnWaveform,...
                                       zoomedOutWaveforms.turnOffWaveform]                        
                    % Repulse for turn on and turn off
                    [ switchingWaveform ] = rescaleAndRepulse(myScope, myFGen, testChannel , scalingWaveform, settings);
                    
                    % Process Results
                    if scalingWaveform.isTurnOn
                        onWaveform = switchingWaveform.turnOnWaveform;
                    else
                        offWaveform = switchingWaveform.turnOffWaveform;
                        
                        % Set overview Waveform
                        if testChannel == 4
                            overviewWaveform = switchingWaveform;
                        end
                    end
                end
                % Create Results Object
                dpResults = DoublePulseResults(onWaveform, offWaveform);
                dpResults.fullWaveform = overviewWaveform;
%                 dpResults.plotResults;
                
                % Save in SweepResults Object
                sweepResults.addResult(testChannel, busVoltage, dpResults);
                
                % Anonymous function to convert variable name to string
                vName=@(x) inputname(1);
                
                % Save Result
                file_name = [settings.dataDirectory num2str(busVoltage)...
                    'V_' num2str(loadCurrent) 'A_' num2str(testChannel) 'CH.mat'];
                save(file_name, vName(dpResults));
            end
        end
    end
    
    % Save Sweep Results
    save([settings.dataDirectory 'sweep_results.mat'], 'sweepResults');
    
    % Plot Sweep Results
    sweepResults.plotEOn;

    % Disconnect from instruments
    myScope.disconnect;
    myFGen.disconnect;

    % Process Measurements
    %% Find Deskew
end

function cleanupDPT(myScope, myFGen, myBusSupply)
    % Turn off Bus Supply
    myBusSupply.outputOffZero;

    % Disconnect from instruments
    myScope.disconnect;
    myFGen.disconnect;
    myBusSupply.disconnect;
end