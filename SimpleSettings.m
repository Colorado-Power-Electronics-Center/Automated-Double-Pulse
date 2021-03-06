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

function [ settings ] = SimpleSettings()
    dpt_settings = DPTSettings;

    % Double Pulse Test Settings
    %% Test Specific Settings
    dpt_settings.busVoltages = [100];
    dpt_settings.loadCurrents = 5; %[2,5:5:35];
    dpt_settings.currentResistor = 50E-3;
    dpt_settings.loadInductor = 720E-6;
    dpt_settings.maxGateVoltage = 7;
    dpt_settings.minGateVoltage = -6;
    dpt_settings.gateLogicVoltage = 5;
    dpt_settings.plotLoss = false;
    dpt_settings.plotWaveforms = false;
    dpt_settings.saveFullWaveforms = false;

    %% Instrument Setup
    % VISA Resource Strings
    dpt_settings.scopeVisaAddress = 'USB0::0x0699::0x0502::C051196::0::INSTR';
    dpt_settings.FGenVisaAddress = 'USB0::0x0957::0x2307::MY50000715::0::INSTR';
    dpt_settings.BusSupplyVisaAddress = 'ASRL5::INSTR';

    %% Channel Setup
    % Channel Numbers
    dpt_settings.channel.VDS = 1;
    dpt_settings.channel.VGS = 2;
    dpt_settings.channel.ID = 4;
    dpt_settings.channel.Vcomplementary = 3;
%     dpt_settings.channel.IL = 3; % Comment out if not measuring

    %% Vertical Settings
    % Initial Veritcal Settings
    dpt_settings.maxCurrentSpike = 100;
    dpt_settings.percentBuffer = 10;
    dpt_settings.calcDefaultScales;
    
    dpt_settings.autoBusControl = true;
    
    %% Horizontal Settings
    % Turn on Window
    dpt_settings.window.turn_on_prequel = 100e-9;
    dpt_settings.window.turn_on_time = 300e-9;

    % Turn off Window
    dpt_settings.window.turn_off_prequel = 100e-9;
    dpt_settings.window.turn_off_time = 300e-9;
    
    % Set Desired Deskew
    dpt_settings.currentDelay = -3.6e-9;
    dpt_settings.vcompDelay = 8e-9;
    
    %% Data Settings
%     dpt_settings.appendFile = 'Measurements\sweep_results.mat';
    dpt_settings.dataDirectory = 'Measurements\';
       
    %% Pulse Creation
    pulse_lead_dead_t = 1e-6;
    pulse_off_t = 5e-6;
    pulse_second_pulse_t = 5e-6;
    pulse_end_dead_t = 1e-6;
        
    settings = dpt_settings;
end