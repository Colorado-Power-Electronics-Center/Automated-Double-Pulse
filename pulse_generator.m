function [ pulse_waveform, total_time ] = pulse_generator( sampleRate, varargin )
%pulse_generator Summary of this function goes here
%   Detailed explanation goes here

times = cell2mat(varargin);

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

