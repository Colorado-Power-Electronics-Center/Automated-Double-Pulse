function [ switching_idx, turn_off_idx, turn_on_idx, turn_on_voltage,...
    turn_on_gate, turn_on_current, turn_on_time, turn_on_offset ] = ...
    extract_turn_on_waveform( busVoltage, V_DS, V_GS, I_D, time )
%extract_turn_on_waveform Summary of this function goes here
%   Detailed explanation goes here

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
    buffer_idx = ceil((turn_on_idx - turn_off_idx) / 2);
    turn_on_voltage = V_DS(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    turn_on_gate = V_GS(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    turn_on_current = I_D (turn_on_idx - buffer_idx : turn_on_idx + buffer_idx);
    turn_on_time = time(turn_on_idx - buffer_idx : turn_on_idx + buffer_idx) - time(turn_on_idx - buffer_idx);
    
    % Determine Turn on offset (i.e. how to recover orginal idx from turn
    % on waveform)
    turn_on_offset = turn_on_idx - buffer_idx - 1;
end

