function [ settings ] = SimpleSettings()
    dpt_settings = DPTSettings;

    % Double Pulse Test Settings
    %% Test Specific Settings
    dpt_settings.busVoltages = [100, 200, 300, 400];
    dpt_settings.loadCurrents = [3, 5, 10, 20, 30];
    dpt_settings.currentResistor = 102E-3;
    dpt_settings.loadInductor = 720E-6;
    dpt_settings.minGateVoltage = -3;
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

    %% Deskew Settings
        dpt_settings.deskewVoltage = 300;
        dpt_settings.deskewCurrent = 15;

    %% Vertical Settings
    % VDS Vertical Settings (This value will only be used for the initial deskew pulse)
    dpt_settings.calcScale(dpt_settings.VDS_Channel, 0, dpt_settings.deskewVoltage, 100)
    % VGS Vertical Settings (This value will be used for all initial pulses)
    dpt_settings.calcScale(dpt_settings.VGS_Channel, dpt_settings.minGateVoltage,...
                           dpt_settings.maxGateVoltage, 50)
    % ID Vertical Settings (This value will be used for all initial pulses)
    dpt_settings.calcScale(dpt_settings.ID_Channel, -dpt_settings.maxCurrentSpike,...
                           max([dpt_settings.maxCurrentSpike, dpt_settings.loadCurrents]), 100)

    % Triggers
    dpt_settings.triggerSource = dpt_settings.VDS_Channel;

    %% Data Saving
        % Data Directory
        dpt_settings.dataDirectory = 'Measurements\testing\full_sweep2\';
       
    settings = dpt_settings;
end