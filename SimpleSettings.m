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
    dpt_settings.busVoltages = [200];
    dpt_settings.loadCurrents = [2,5:5:30,32];
    dpt_settings.currentResistor = 50E-3;
    dpt_settings.loadInductor = 720E-6;
    dpt_settings.maxGateVoltage = 7;
    dpt_settings.minGateVoltage = -6;
    dpt_settings.gateLogicVoltage = 5;

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
    dpt_settings.channel.VSYNC = 3;
%     dpt_settings.channel.IL = 3; % Comment out if not measuring

    %% Vertical Settings
    % Initial Veritcal Settings
    dpt_settings.maxCurrentSpike = 300;
    dpt_settings.percentBuffer = 110;
    dpt_settings.calcDefaultScales;
    
    dpt_settings.autoBusControl = true;
    
    %% Horizontal Settings
    % Turn on Window
    dpt_settings.window.turn_on_prequel = 50e-9;
    dpt_settings.window.turn_on_time = 200e-9;

    % Turn off Window
    dpt_settings.window.turn_off_prequel = 50e-9;
    dpt_settings.window.turn_off_time = 200e-9;
    
    % Set Desired Deskew
    dpt_settings.currentDelay = 5e-9;
    
    %% Data Settings
%     dpt_settings.appendFile = 'Measurements\sweep_results.mat';
    dpt_settings.dataDirectory = 'Measurements\3\';
       
    settings = dpt_settings;
end