function [ settings ] = SimpleSettings()
    dpt_settings = DPTSettings;

    % Double Pulse Test Settings
    %% Test Specific Settings
    dpt_settings.busVoltages = [100, 200, 300, 400];
    dpt_settings.loadCurrents = [3, 5, 10, 20, 30];
    dpt_settings.currentResistor = 102E-3;
    dpt_settings.loadInductor = 720E-6;
    dpt_settings.maxGateVoltage = 10;
    dpt_settings.gateLogicVoltage = 5;

    %% Instrument Setup
    % VISA Resource Strings
    dpt_settings.scopeVisaAddress = 'USB0::0x0699::0x0502::C051196::0::INSTR';
    dpt_settings.FGenVisaAddress = 'USB0::0x0957::0x2307::MY50000715::0::INSTR';

    %% Channel Setup
    % Channel Numbers
    dpt_settings.channel.VDS = 1;
    dpt_settings.channel.VGS = 2;
    dpt_settings.channel.ID = 4;
    dpt_settings.channel.IL = 3; % Comment out if not measuring

    %% Vertical Settings
    dpt_settings.calcDefaultScales;
       
    settings = dpt_settings;
end