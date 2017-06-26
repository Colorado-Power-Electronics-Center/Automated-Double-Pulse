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

function [ returnWaveforms ] = runDoublePulseTest( myScope, myFGen,...
    loadCurrent, busVoltage, settings )
%runDoublePulseTest Summary of this function goes here
%   Detailed explanation goes here
    %%% Unpack Settings %%%
    loadInductor = settings.loadInductor;
    currentResistor = settings.currentResistor;
    
    %% Channel Setup
    % Channel Numbers
    VDS_Channel = settings.VDS_Channel;
    VGS_Channel = settings.VGS_Channel;
    ID_Channel = settings.ID_Channel;
    IL_Channel = settings.IL_Channel;
    Vcomplementary_Channel = settings.Vcomplementary_Channel;
    
    %% Pulse Creation
    gateLogicVoltage = settings.gateLogicVoltage;
    pulse_lead_dead_t = settings.pulse_lead_dead_t;
    pulse_off_t = settings.pulse_off_t;
    pulse_second_pulse_t = settings.pulse_second_pulse_t;
    pulse_end_dead_t = settings.pulse_end_dead_t;

    % Burst Settings
    burstMode = settings.burstMode;
    FGenTriggerSource = settings.FGenTriggerSource;
    burstCycles = settings.burstCycles;
    
    %% Pulse Measurement
    scopeSampleRate = settings.scopeSampleRate;
    scopeRecordLength = settings.scopeRecordLength;
    
    % Waveform
    numBytes = settings.numBytes;
    encoding = settings.encoding;
    numVerticalDivisions = settings.numVerticalDivisions;

    % Probe Gains
    chProbeGain = settings.chProbeGain;

    % Initial Vertical Settings
    chInitialOffset = settings.chInitialOffset;
    chInitialScale = settings.chInitialScale;
    chInitialPosition = settings.chInitialPosition;

    % Initial Horizontal Settings
    horizontalScale = settings.horizontalScale;
    delayMode = settings.delayMode;
    horizontalPosition = settings.horizontalPosition;

    % Trigger 
    triggerType = settings.triggerType;
    triggerCoupling = settings.triggerCoupling;
    triggerSlope = settings.triggerSlope;
    triggerSource = settings.triggerSource;
    triggerLevel = settings.triggerLevel;

    % Acquisition
    acquisitionMode = settings.acquisitionMode;
    acquisitionSamplingMode = settings.acquisitionSamplingMode;
    acquisitionStop = settings.acquisitionStop;
    
    % Reset to default state
    myScope.reset;
    myScope.clearStatus;
    myFGen.reset;
    myFGen.clearStatus;

    %% Pulse Creation
    % Find Function Generator Maximum Sample Rate
    sampleRate = myFGen.getArbSampleRate(1, 'MAXimum');

    % Setup CH1 Waveform
    % Calculate first pulse duration
    pulse_first_pulse_t = loadInductor * (loadCurrent / busVoltage);

    % Generate Double Pulse
    [ch1_wave_points, total_time] = pulse_generator(sampleRate,... 
        pulse_lead_dead_t, pulse_first_pulse_t, pulse_off_t,... 
        pulse_second_pulse_t, pulse_end_dead_t);

    % Load Waveform
    myFGen.loadArbWaveform(ch1_wave_points, sampleRate, gateLogicVoltage, 'double_pulse', 1);

    % Setup Burst
    myFGen.setupBurst(burstMode, burstCycles, total_time, FGenTriggerSource, 1);

    % Set Load
    myFGen.setOutputLoad(1, 'INFinity');

    % Setup CH2 Waveform
    % Generate Single Pulse
%     if ~settings.use_mini_2nd_pulse
    [ch2_wave_points, ~] = pulse_generator(sampleRate,...
        pulse_lead_dead_t + pulse_first_pulse_t + .1 * pulse_off_t,...
        .8 * pulse_off_t,...
        .1 * pulse_off_t + pulse_second_pulse_t + pulse_end_dead_t);
%     else
%         second_pulse_off_t = settings.mini_2nd_pulse_off_time;
%         [ch2_wave_points, ~] = pulse_generator(sampleRate,...
%             0, pulse_lead_dead_t + pulse_first_pulse_t + pulse_off_t + 17e-9,...
%             second_pulse_off_t, pulse_second_pulse_t);
%     end

    % Load Waveform
    myFGen.loadArbWaveform(ch2_wave_points, sampleRate, gateLogicVoltage, 'single_pulse', 2);

    % Setup Burst
    myFGen.setupBurst(burstMode, burstCycles, total_time, FGenTriggerSource, 2);

    % Set Load
    myFGen.setOutputLoad(2, 'INFinity');

    %% Pulse Measurement
    % Ensure all Channels on
    myScope.allChannelsOn;
    
    % Set Channel Label Names
    myScope.setChLabelName(VDS_Channel, 'V_DS');
    myScope.setChLabelName(VGS_Channel, 'V_GS');
    myScope.setChLabelName(ID_Channel, 'I_D');
    myScope.setChLabelName(IL_Channel, 'I_L');
    myScope.setChLabelName(Vcomplementary_Channel, 'V_comp');
    
    % Turn Off Headers
    myScope.removeHeaders;

    % Set Scope Dependent Properties
    if myScope.scopeSeries == SCPI_Oscilloscope.Series5000
        % Set Horizontal Axis to manual mode
        myScope.horizontalMode = 'MANual';
        
        % Set Load Current Channel Attenuation
        myScope.setChExtAtten(settings.ID_Channel, 1/settings.currentResistor);
        myScope.setChExtAttenUnits(settings.ID_Channel, 'A'); 
    else
        % Set Data Resolution to Full
        myScope.dataResolution = 'FULL';
    end

    % Set scope sample rate and record length
    myScope.sampleRate = scopeSampleRate;
    myScope.acqSamplingMode = acquisitionSamplingMode;
    if settings.useAutoRecordLength
        myScope.recordLength = total_time * myScope.sampleRate...
            * settings.autoRecordLengthBuffer;
    else
        myScope.recordLength = scopeRecordLength;
    end

    % Setup Probe Gains of necessary
    if myScope.scopeSeries == SCPI_Oscilloscope.Series4000
        for channel = 1:4
            myScope.setChProbeGain(channel, chProbeGain(channel));
        end
    else
        % todo
    end

    % Set Oscilloscope Deskew
    myScope.setChDeskew(settings.ID_Channel, settings.currentDelay);
    myScope.setChDeskew(settings.VGS_Channel, settings.VGSDeskew);
    
    % Set Scope Channel Termination
    myScope.setChTermination(settings.ID_Channel, 50);
    
    % Set Initial Vertical Settings
    for channel = 1:4
        myScope.setChOffSet(channel, chInitialOffset(channel));
        myScope.setChScale(channel, chInitialScale(channel));
        myScope.setChPosition(channel, chInitialPosition(channel));
    end
    
    % Set I_L Scaling to the same as I_D
    if settings.IL_Channel > 0
        myScope.setChScale(settings.IL_Channel, myScope.getChScale(settings.ID_Channel));
        myScope.setChPosition(settings.IL_Channel, myScope.getChPosition(settings.ID_Channel));
    end
    
    % Invert Current Channel
    if settings.invertCurrent
        if myScope.scopeSeries ~= SCPI_Oscilloscope.Series5000
            myScope.setChInvert(ID_Channel, 'ON');
            if IL_Channel ~= GeneralWaveform.NOT_RECORDED
                myScope.setChInvert(IL_Channel, 'ON');
            end
        else
            % 5000 Series Scopes do not support inverting, but we will do
            % it later manually.
            myScope.setChInvert(ID_Channel, 'OFF');
        end
    else
        myScope.setChInvert(ID_Channel, 'OFF');
    end
    
    % Set Current Probe Range
    if IL_Channel > 0
        myScope.setChProbeControl(IL_Channel, 'MANual');
        myScope.setChProbeForcedRange(IL_Channel, 30);
    end

    % Set Initial Horizontal Axis
    myScope.horizontalScale = horizontalScale;
    myScope.horizontalDelayMode = delayMode;
    myScope.horizontalPosition = horizontalPosition;

    % Setup Trigger
    myScope.setupTrigger(triggerType, triggerCoupling, triggerSlope,...
        triggerSource, triggerLevel);

    % Setup Acquisition
    myScope.acqMode = acquisitionMode;
    myScope.acqStopAfter = acquisitionStop;
    myScope.acqState = 'RUN';

    pause(3);

    % Trigger Waveform
    myFGen.push2Trigger('pulse', settings.push2pulse);

    % Setup binary data for the CURVE query
    myScope.setupWaveformTransfer(numBytes, encoding);
    
    pause(1);

    % Check if trigger received
    if myScope.acqState ~= 0
        error('Trigger not detected');
    end
    
    % Get all four waveforms
    WaveForms = cell(1, 4);

    for idx = myScope.enabledChannels
        WaveForms{idx} = myScope.getWaveform(idx);
    end
    
    % Create time vector
    WaveForms{end + 1} = (0:myScope.recordLength - 1) / myScope.sampleRate;
    
    % Create Waveform result
    fullWvFm = FullWaveform.fromChannelCell(WaveForms, settings.channel,...
        busVoltage, settings.window);
    
    % Return Waveforms
    returnWaveforms = fullWvFm;
end
