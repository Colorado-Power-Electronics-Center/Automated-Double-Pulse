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
    
    % Ensure Channels are all on
    myScope.allChannelsOn;
    
    % Turn Off I_L and V_GS is 2 Channel measurement
    if numChannels == 2
        myScope.channelsOff([settings.IL_Channel settings.VGS_Channel]);
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
        WaveForms{settings.channel.IL} = WaveForms{settings.channel.IL} * -1;
    end
    
    % Create Waveform result
    fullWvFm = FullWaveform.fromChannelCell(WaveForms, settings.channel,...
        scalingWaveforms.approxBusVoltage, settings.window);
    
    % Return Waveforms
    returnWaveforms = fullWvFm;
end