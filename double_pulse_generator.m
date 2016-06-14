function [ double_pulse_waveform, sample_rate, total_time ] = double_pulse_generator( lead_dead_t, first_pulse_t, off_t, second_pulse_t, end_dead_t )
%double_pulse_generator Summary of this function goes here
%   Detailed explanation goes here

maxSampleRate = 250e6;

times = [lead_dead_t, first_pulse_t, off_t, second_pulse_t, end_dead_t];
% min_time = min(times);
% 
% time_diffs = diff(sort(times));
% min_diff = min(time_diffs(time_diffs > 0));
% 
% 
% time_sample_rate = 1 / min_time;
% diff_sample_rate = 1 / min_diff;
% 
% min_sample_rate = min([time_sample_rate diff_sample_rate]) * 100;
% 
% % Do not allow sample rates greater than max sample rate
% if min_sample_rate > maxSampleRate
%     sample_rate = maxSampleRate;
% end

% Always set sample rate to maxSampleRate
sample_rate = maxSampleRate;

zeros_next = true;
wave_form = [];

for time = times
    num_points = round(time * sample_rate);
    
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

