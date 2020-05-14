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

function [ pulse_waveform, total_time ] = pulse_generator( sampleRate, varargin )
%pulse_generator Summary of this function goes here
%   Detailed explanation goes here

if numel(varargin) > 1
    times = cell2mat(varargin);
else
    times = varargin{1};
end
    

zeros_next = true;
wave_form = [];

for time = times
    num_points = round(time * sampleRate);
    
    if zeros_next == true
        wave_form = [wave_form zeros(1, num_points)];
        zeros_next = false;
    else
        wave_form = [wave_form ones(1, num_points)];
        zeros_next = true;
    end
end

pulse_waveform = wave_form;

total_time = sum(times);

end

