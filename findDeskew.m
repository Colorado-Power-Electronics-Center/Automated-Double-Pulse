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

%% findDeskew
% Use di/dt method to deskew voltage and current measurements.
% Returns the delay in the curent signal, e.g. if the current lags the
% voltage by 5ns the function will return +5ns.
function delay = findDeskew(voltage, current, time)
    % find real bus voltages
    % find approximate switching point
    [~, switch_idx] = max(abs(diff(voltage)));
    
    % find real bus voltage
    V_bus = mean(voltage(1:(floor(switch_idx / 2))));
    
    % find real load current
    I_load = mean(current(end-(floor(switch_idx / 2)):end));
    
    % Maximum Allowable Skew
    max_skew  = 5e-9;
    % Minimum Desired Skew
    min_skew  = 10e-12;
    
    % Interpolate waveform to find skew more precisely
    f_time = time(1) : min_skew : time(end);
    f_voltage = interp1(time, voltage, f_time, 'spline') - V_bus;
    f_current = interp1(time, current, f_time, 'spline');
    
    % Find starting and stoping indexs for current
    i_start = find(f_current - 0.1 * I_load < 0, 1, 'last');
    i_end = find(f_current - 0.9 * I_load > 0, 1);
    i_start = 2 * i_start - i_end;
    
    % Find starting and stopping indexs for voltage
    v_start = max(1, round(i_start - max_skew / min_skew));
    v_end = min(length(f_voltage), round(i_end + max_skew / min_skew));
    
    % Slice Current and Voltage Waveforms
    on_current = f_current(i_start:i_end);
    on_voltage = f_voltage(v_start:v_end);
    
    % Take derivative of Current
    di_dt = diff(on_current) / min_skew;
    
    % Find unadjusted delay
    u_delay = finddelay(on_voltage, di_dt);
    
    % Adjust delay to take into account differing sizes of on_voltage and
    % di_dt.
    idx_delay = u_delay + (i_start - v_start);
    
    % Convert Delay to time
    delay = idx_delay * min_skew;
    
    
    
    