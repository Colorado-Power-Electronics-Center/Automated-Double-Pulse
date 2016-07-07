function [ returnWaveforms ] = rescaleAndRepulse(myScope, myFGen, numChannels, fullWaveforms, settings)
    % Create Waveform Cell
    waveforms = fullWaveforms.channelOrderedCell;
    
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
    
    % Set Samplerate and record Length
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
    myFGen.push2Trigger('pulse');

    pause(2);
    
    % Check if trigger recieved
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
    
    % Invert Series 5000 Scopes
    if settings.invertCurrent && strcmp(myScope.scopeSeries, myScope.Series5000)
        WaveForms{settings.channel.ID} = WaveForms{settings.channel.ID} * -1;
        WaveForms{settings.channel.IL} = WaveForms{settings.channel.IL} * -1;
    end
    
    % Create Waveform result
    fullWvFm = FullWaveform.fromChannelCell(WaveForms, settings.channel,...
        fullWaveforms.aproxBusVoltage, settings.window);
    
    % Return Waveforms
    returnWaveforms = fullWvFm;
end