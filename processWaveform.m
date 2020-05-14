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

%% processWaveform
% Take saved waveform file and process the data. Output graphs and
% characteristics. 
function processWaveform(data, settings)
    load(data);
    if nargin == 1
        settings = [pwd '\' fileparts(data) '\Measurement_Settings.m'];
    end
    run(settings);
    
    % Bus Voltage
    busVoltage;
    
    % Load Current
    loadCurrent;
    
    % VDS Waveform
    V_DS;
    
    % VGS Waveform
    V_GS;
    
    % ID Waveform
    I_D;
    
    % Create time vector
    time_step = 1 / settings.scopeSampleRate;
    time = (0:(numel(V_DS) - 1)) * time_step;
    
    % Extract Turn on waveform
    [ switching_idx, turn_off_idx, turn_on_idx, V_DS_on,...
    V_GS_on, I_D_on, turn_on_time, turn_on_offset ] = ...
    extract_turn_on_waveform( busVoltage, V_DS, V_GS, I_D, time );
    
    % Find Deskew
    current_delay = findDeskew(V_DS_on, I_D_on, turn_on_time);
    
    if current_delay > 500e-12
        disp('WARNING: deskew greater than 500 pS');
    end
    
    % Find Bus Voltage, Load Current, and Gate Voltage
    % Bus Voltage
    % Use average value between turn off and turn on
    dead_idxs = turn_on_idx - turn_off_idx;
    buffer_idxs = ceil(dead_idxs / 4);
    v_bus = mean(V_DS(turn_off_idx + buffer_idxs:turn_on_idx-buffer_idxs));
    
    % Load Current
    % Use average value after turn on
    on_idxs = switching_idx(end) - turn_on_idx;
    buffer_idxs = ceil(on_idxs / 4);
    i_load = mean(I_D(turn_on_idx + buffer_idxs : switching_idx(end) - buffer_idxs));
    
    % Gate Voltage
    % Use average value prior to turn off
    buffer_idxs = ceil(dead_idxs / 4);
    v_gate = mean(VGS(turn_off_idx - dead_idxs : turn_off_idx - buffer_idxs));
    
    % Find Gate Turn on idx
    % Point in V_GS turn on waveform where voltage starts to increase and 
    % does not stop increasing
    vgs_on_idx = find_on_idx(V_GS_on, v_gate, turn_on_offset);
    
    % Find Current Turn on idx
    % Point in I_D turn on waveform where current starts to increase and
    % does not stop increasing
    id_on_idx = find_on_idx(I_D_on, i_load, turn_on_offset);
    
    % Find turn on delay, td_on, the time from gate rise start to current
    % rise start.
    td_on_idx = id_on_idx - vgs_on_idx;
    td_on = td_on_idx * time_step;
    
    % Find Current Rise time, t_cr, the time for the current to rise from 0
    % to the load current.
    id_at_load_idx = find(I_D_on > i_load, 1) + turn_on_offset;
    t_cr_idx = id_at_load_idx - id_on_idx;
    t_cr = t_cr_idx * time_step;
    
    % Find Voltage Fall time, t_vf, the time it takes for the voltage to
    % reach zero after the voltage starts falling. We can say that the
    % voltage will start falling at the same time the current starts
    % rising.
    v_ds_at_0_idx = find(V_DS_on < 0, 1) + turn_on_offset;
    t_vf_idx = v_ds_at_0_idx - id_on_idx;
    t_vf = t_vf_idx * time_step;
    
    % Calculate on time, t_on, the time from initial V_GS rise to final
    % V_DS fall. 
    t_on_idx = v_ds_at_0_idx - vgs_on_idx;
    t_on = t_on_idx * time_step;
    
    
end

function [on_idx] = find_on_idx(on_wave_form, peak_value, offset)
    on_diff = diff(on_wave_form);
    half_on_idx = find(on_wave_form > peak_value / 2, 1);
    on_idx = find(on_diff(1:half_on_idx) < 0, 1, 'last') + 1;
    on_idx = on_idx + offset;
end
    
    