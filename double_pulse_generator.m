function [ double_pulse_waveform, total_time ] = double_pulse_generator( lead_dead_t, first_pulse_t, off_t, second_pulse_t, end_dead_t, sampleRate )
%double_pulse_generator Summary of this function goes here
%   Detailed explanation goes here

times = [lead_dead_t, first_pulse_t, off_t, second_pulse_t, end_dead_t];

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

double_pulse_waveform = wave_form;

total_time = sum(times);

end

