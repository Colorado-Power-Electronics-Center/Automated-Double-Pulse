function setVoltageToLoad(myScope, busVoltage, settings)
    myScope.channelsOn(settings.VDS_Channel);
    myScope.minMaxRescaleChannel(settings.VDS_Channel, 0, busVoltage,...
        settings.numVerticalDivisions, settings.percentBuffer);
    % Get Current acqStop After
    prevStopAfter = myScope.acqStopAfter;
    
    myScope.acqStopAfter = 'RUNSTop';
    myScope.acqState = 'ON';
    disp(['Set voltage to ' num2str(busVoltage) 'V and press any key...'])
    pause;
    
    % Reset Scope to previous Stop After
    myScope.acqStopAfter = prevStopAfter;
end