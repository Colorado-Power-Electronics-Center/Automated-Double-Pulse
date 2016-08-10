function setVoltageToLoad(myScope, myBusSupply, busVoltage, settings)
    curVoltage = myBusSupply.outVoltage;
    
    myScope.channelsOn(settings.VDS_Channel);
    myScope.minMaxRescaleChannel(settings.VDS_Channel, 0,...
        max(busVoltage, curVoltage),...
        settings.numVerticalDivisions, settings.percentBuffer);
    % Get Current acqStop Settings
    prevStopAfter = myScope.acqStopAfter;
    prevRecordLength = myScope.recordLength;
    
    myScope.acqStopAfter = 'RUNSTop';
    myScope.acqState = 'ON';
    myScope.recordLength = 1000;
    
    % Either ask user to do it or do it automatically per settings
    if settings.autoBusControl
        % Setup Measurement on oscilloscope
        myScope.setImmediateMeasurementSource(settings.channel.VDS);
        myScope.setImmediateMeasurementType('MEAN');
        
        % Separate voltage change into 10 sections        
        steps = linspace(curVoltage, busVoltage, 10);
        
        % Skip first element as it is the current voltage
        for step = steps(2:end)
            % Set voltage with slew to each section
            myBusSupply.setSlewedVoltage(step, settings.busSlewRate);
            
            % Check that drain voltage is actually the bus voltage
            v_ds = myScope.getImmediateMeasurementValue;
            % ceil and +1 give a little more buffer at low voltages,
            % without making it too large at high voltages. 
            if abs(step - v_ds) > ceil(.05 * step) + 1
                error('V_DS not within ~5% of Bus Supply');
            end
        end
    else
        disp(['Set voltage to ' num2str(busVoltage) 'V and press any key...'])
        pause;
    end
    
    % Reset Scope to previous ACQ Settings
    myScope.acqStopAfter = prevStopAfter;
    myScope.recordLength = prevRecordLength;
end