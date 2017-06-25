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

function [ returnWaveforms ] = rescaleAndRepulse(myScope, myFGen, numChannels, scalingWaveforms, settings)
    % Create Waveform Cell
    waveforms = scalingWaveforms.channelOrderedCell;
    
    % Rescale Oscilloscope VDS, VGS, and ID Channels
    for channel = [settings.VDS_Channel settings.VGS_Channel settings.ID_Channel]
        myScope.rescaleChannel(channel, waveforms{channel},...
            settings.numVerticalDivisions, settings.percentBuffer);
    end
    
    % Rescale Oscilloscope IL Channel
    if settings.IL_Channel > 0
        myScope.setChScale(settings.IL_Channel, myScope.getChScale(settings.ID_Channel));
        myScope.setChPosition(settings.IL_Channel, myScope.getChPosition(settings.ID_Channel));
    end
    
    % Rescale Oscilloscope IL Channel
    if settings.channel.Vcomplementary > 0
        myScope.setChScale(settings.channel.Vcomplementary, myScope.getChScale(settings.channel.Vcomplementary));
        myScope.setChPosition(settings.channel.Vcomplementary, myScope.getChPosition(settings.channel.Vcomplementary));
    end
    
    % Ensure Channels are all on
    myScope.allChannelsOn;
    
    % Turn Off I_L and V_GS if 2 Channel measurement
    if numChannels == 2
        myScope.channelsOff([settings.IL_Channel settings.VGS_Channel settings.channel.Vcomplementary]);
    end
    
    % Set Sample rate and record Length
    total_time = myFGen.numQuery('SOURce1:BURSt:INTernal:PERiod?');
    myScope.sampleRate = settings.scopeSampleRate;
    if settings.useAutoRecordLength
        myScope.recordLength = total_time * myScope.sampleRate...
            * settings.autoRecordLengthBuffer;
    else
        myScope.recordLength = scopeRecordLength;
    end

    % Rerun Capture
    myScope.acqState = 'RUN';

    pause(1);

    % Trigger Waveform
    myFGen.push2Trigger('pulse', settings.push2pulse);

    pause(2);
    
    % Check if trigger received
    if myScope.acqState ~= 0
        error('Trigger not detected');
    end

    % Get all four waveforms
    WaveForms = cell(1, 4);
    [WaveForms{:}] = deal(GeneralWaveform.NOT_RECORDED);

    for idx = myScope.enabledChannels
        WaveForms{idx} = myScope.getWaveform(idx);
    end
    
    % Create time vector
    WaveForms{end + 1} = (0:myScope.recordLength - 1) / myScope.sampleRate;
    
    % If 2 Channel Interpolate vgs from scaling waveform and add to vgs
    % Channel, This allows us to get approximate values for the waveform
    % processing. This does not affect the energy calculations, but does
    % effect all calculations that rely on the gate timing. The two channel
    % waveform results should not be considered accurate for these
    % measurements. 
%     if numChannels == 2
%         scaledVGS = waveforms{settings.channel.VGS};
%         scaledTime = waveforms{end};
%         upSampleTime = WaveForms{end};
%         upSampleVGS = interp1(scaledTime, scaledVGS, upSampleTime, 'spline');
%         WaveForms{settings.channel.VGS} = upSampleVGS;
%     end
    
    % Invert Series 5000 Scopes
    if settings.invertCurrent && strcmp(myScope.scopeSeries, myScope.Series5000)
        WaveForms{settings.channel.ID} = WaveForms{settings.channel.ID} * -1;
        if settings.channel.IL ~= GeneralWaveform.NOT_RECORDED
            WaveForms{settings.channel.IL} = WaveForms{settings.channel.IL} * -1;
        end
    end
    
    % Create Waveform result
    fullWvFm = FullWaveform.fromChannelCell(WaveForms, settings.channel,...
        scalingWaveforms.approxBusVoltage, settings.window);
    
    % Return Waveforms
    returnWaveforms = fullWvFm;
end