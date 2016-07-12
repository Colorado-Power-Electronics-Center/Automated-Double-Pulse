function setVoltageToLoad(myScope, busVoltage, settings)
    myScope.channelsOn(settings.VDS_Channel);
    myScope.minMaxRescaleChannel(settings.VDS_Channel, 0, busVoltage,...
        settings.numVerticalDivisions, settings.percentBuffer);
    % Get Current acqStop After
    prevStopAfter = myScope.acqStopAfter;
    
    % Either aske user to do it or do it automatically per settings
    if settings.autoBusControl
        % todo
    else
        myScope.acqStopAfter = 'RUNSTop';
        myScope.acqState = 'ON';
        disp(['Set voltage to ' num2str(busVoltage) 'V and press any key...'])
        pause;
    end
    
    % Reset Scope to previous Stop After
    myScope.acqStopAfter = prevStopAfter;
end