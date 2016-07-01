function [ V_DS, I_D, V_GS, time ] = rescaleAndRepulse(myScope, myFGen, numChannels, waveforms, settings)
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

    % Get Desired waveforms
    V_DS = myScope.getWaveform(settings.VDS_Channel);
    I_D = myScope.getWaveform(settings.ID_Channel) * -1;
    
    if numChannels == 4
        V_GS = myScope.getWaveform(settings.VGS_Channel);
    else
        V_GS = settings.notRecorded;
    end
    
    % Create time vector
    time = (0:myScope.recordLength - 1) / myScope.sampleRate;
end