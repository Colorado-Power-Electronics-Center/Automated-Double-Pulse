function setVoltageToLoad(myScope, busVoltage, settings)
    myScope.channelsOn(settings.VDS_Channel);
    myScope.minMaxRescaleChannel(settings.VDS_Channel, 0, busVoltage,...
        settings.numVerticalDivisions, settings.percentBuffer);
    myScope.acqState = 'ON';
    disp(['Set voltage to ' num2str(busVoltage) 'V and press any key...'])
    pause;
end