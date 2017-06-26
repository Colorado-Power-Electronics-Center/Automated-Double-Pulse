%{
    Part of the Automated Double Pulse Test Project
    Copyright (C) 2017  Kyle Goodrick

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Kyle Goodrick: Kyle.Goodrick@Colorado.edu
%}

function Synchronous_Double_Pulse_Test(settings)
    % Create Copy of Settings File in data Folder
    if ~exist(settings.dataDirectory, 'dir')
        mkdir(settings.dataDirectory);
    end
    save([settings.dataDirectory 'Measurement_Settings.mat'], 'settings');

    %% Setup
    % Clear MATLAB Workspace of any previous instrument connections
    instrreset;
    
    settings.triggerSlope = 'RISe';

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
    myBusSupply.visaObj.Timeout = settings.scopeTimeout; % Use same timeout as scope
    
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
    
    % Find Deskew if no append file is given
    if settings.appendFile == false % If not appending to existing sweep
        % Create Sweep results Object
    	syncSweepResults = SweepResults;
        syncSweepResults.currentDelay = settings.currentDelay;
    else % If appending to file load load old sweep result and get its current delay
        load Measurements\sync_sweep_results.mat
        settings.currentDelay = syncSweepResults.currentDelay; %#ok<NODEF>
    end    
    
    
    % Obtain Measurements
    for busVoltage = settings.busVoltages    
        % set Voltage (user or auto)
        setVoltageToLoadForSynchronousDPT(myScope, myBusSupply, busVoltage, settings);
        
        % Change VDS Vertical Settings to account for new bus voltage
        settings.calcScale(settings.VDS_Channel, 0, busVoltage, 200);
        if (settings.channel.Vcomplementary ~= GeneralWaveform.NOT_RECORDED)
            settings.calcScale(settings.channel.Vcomplementary, 0, busVoltage, 200);
        end
            
        for loadCurrent = settings.loadCurrents
            % Capture Zoomed Out Waveform
            % Run Zoomed out pulse
            [ zoomedOutWaveforms ] = runDoublePulseTest( myScope, myFGen,...
                loadCurrent, busVoltage, settings );
            for testChannel = [4] %[4, 2]
                onWaveform = [];
                offWaveform = [];
                for scalingWaveform = [zoomedOutWaveforms.turnOnWaveform,...
                                       zoomedOutWaveforms.turnOffWaveform]                        
                    % Repulse for turn on and turn off
                    [ switchingWaveform ] = rescaleAndRepulse(myScope, myFGen, testChannel , scalingWaveform, settings);
                    
                    % Process Results
                    if scalingWaveform.isTurnOn
                        onWaveform = switchingWaveform.turnOnWaveform;
                         % Set overview Waveform
                        if testChannel == 4
                            overviewWaveform = switchingWaveform;
                        end
                    else
                        offWaveform = switchingWaveform.turnOffWaveform;
                       
                    end
                end
                % Create Results Object
                dpResults = SyncDoublePulseResults(onWaveform, offWaveform);
                dpResults.fullWaveform = overviewWaveform;
                if settings.plotWaveforms == true
                    dpResults.plotResults;
                end
                
                % Anonymous function to convert variable name to string
                vName=@(x) inputname(1);
                
                % Save Result
                file_name = [settings.dataDirectory num2str(busVoltage)...
                    'V_' num2str(loadCurrent) 'A_' num2str(testChannel) 'CH.mat'];
                save(file_name, vName(dpResults));

                if settings.saveFullWaveforms == false
                    % Remove Full Waveform waveforms from Double Pulse Results object
                    % This will reduce the size of the sweep result object in memory 
                    % and allow more results to be added to a given sweep. No data
                    % is lost as we just saved the fullWaveform to disk. Only remove 
                    % Waveforms so metadata may still be used if necessary.
                    dpResults.fullWaveform.v_ds = [];
                    dpResults.fullWaveform.v_gs = [];
                    dpResults.fullWaveform.i_d = [];
                    dpResults.fullWaveform.i_l = [];
                    dpResults.fullWaveform.v_complementary = [];
                    dpResults.fullWaveform.time = [];
                end

                % Save in syncSweepResults Object
                syncSweepResults.addResult(testChannel, busVoltage, dpResults);
                                
                fprintf('\nFinished testing %4.0f V, %4.1f A.\n',busVoltage,loadCurrent);
            end
        end
    end
    
    % Save Sweep Results
    save([settings.dataDirectory 'sync_sweep_results.mat'], 'syncSweepResults');
    
    if settings.plotLoss == true
        % Plot Sweep Results
        syncSweepResults.plotEOff;
        syncSweepResults.plotEOn;
    end

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