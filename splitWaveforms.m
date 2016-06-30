function [ turn_on_waveforms, turn_off_waveforms, turn_on_idx,...
    turn_off_idx, turn_on_offset, turn_off_offset, switching_idx ]...
    = splitWaveforms( busVoltage, fullWaveforms, time, settings )
%splitWaveforms Splits Full waveforms into turn off and turn on waveforms.
%   Args: ( busVoltage, fullWaveforms, settings )
%   busVoltage: Aproximate Bus voltage of measurements
%   fullWaveforms: Cell array of waveform vectors. Should contain 4
%   elements.
%   settings: measurement settings object

    V_DS = fullWaveforms{settings.VDS_Channel};
    V_GS = fullWaveforms{settings.VGS_Channel};
    I_D = fullWaveforms{settings.ID_Channel};
    if settings.IL_Channel > 0
        I_L = fullWaveforms{settings.IL_Channel};
    else
        I_L = settings.notRecorded;
    end

    % Find switching indicies using V_DS curve
    % Round V_DS Curve to on or of
    V_DS_Round = round(V_DS / busVoltage) * busVoltage;
    
    % Find switching indicies
    V_DS_Round_Diff = diff(V_DS_Round);
    switching_idx = find(V_DS_Round_Diff ~= 0);
    
    % Remove Switches that occour within 50 ns of the previous
    time_step = time(2) - time(1);
    num_points = floor(50e-9 / time_step);
    
    switching_idx_diff = diff(switching_idx);
    false_switch_idxs = logical([0 (switching_idx_diff < num_points)]);
    switching_idx(false_switch_idxs) = [];    
    
    % Check if first switch is on or off
    % and define turn on and turn off indexs
    if V_DS_Round_Diff(switching_idx(1)) > 0
        % Turn off
        turn_off_idx = switching_idx(1);
        turn_on_idx = switching_idx(2);
    else
        % Turn on
        turn_off_idx = switching_idx(2);
        turn_on_idx = switching_idx(3);
    end
    
    % Extract turn on waveform
    turn_on_waveforms = cell(1, 4);
    buffer_idx = ceil((turn_on_idx - turn_off_idx) / 2);
    turn_on_waveforms{settings.VDS_Channel} = V_DS(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    turn_on_waveforms{settings.ID_Channel} = I_D(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    if V_GS(1) ~= settings.notRecorded
        turn_on_waveforms{settings.VGS_Channel} = V_GS(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    else
        turn_on_waveforms{settings.VGS_Channel} = settings.notRecorded;
    end
    if I_L(1) ~= settings.notRecorded
        turn_on_waveforms{settings.IL_Channel} = I_L(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    else
        turn_on_waveforms{cellfun(@isempty,turn_on_waveforms)} = settings.notRecorded;
    end
    
    % Extract turn off waveform
    turn_off_waveforms = cell(1, 4);
    buffer_idx = ceil((turn_on_idx - turn_off_idx) / 2);
    turn_off_waveforms{settings.VDS_Channel} = V_DS(turn_off_idx - buffer_idx : turn_off_idx + buffer_idx);
    turn_off_waveforms{settings.ID_Channel} = I_D(turn_off_idx - buffer_idx : turn_off_idx + buffer_idx);
    if V_GS(1) ~= settings.notRecorded
        turn_off_waveforms{settings.VGS_Channel} = V_GS(turn_off_idx - buffer_idx : turn_off_idx + buffer_idx);
    else
        turn_off_waveforms{settings.VGS_Channel} = settings.notRecorded;
    end
    if I_L(1) ~= settings.notRecorded
        turn_off_waveforms{settings.IL_Channel} = I_L(turn_off_idx - buffer_idx : turn_off_idx + buffer_idx);
    else
        turn_off_waveforms{cellfun(@isempty,turn_off_waveforms)} = settings.notRecorded;
    end
    
    % Determine Turn on offset (i.e. how to recover orginal idx from turn
    % on waveform)
    turn_on_offset = turn_on_idx - buffer_idx - 1;
    
    % Determine Turn off offset (i.e. how to recover orginal idx from turn
    % off waveform)
    turn_off_offset = turn_off_idx - buffer_idx - 1;
    
    

end

