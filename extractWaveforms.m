function [ returnWaveforms ] = extractWaveforms(switch_capture, unExtractedWaveforms, busVoltage, settings)
    [ turn_on_waveforms, turn_off_waveforms, ~, ~, ~, ~, ~ ]...
    = splitWaveforms( busVoltage, unExtractedWaveforms, unExtractedWaveforms{waveformTimeIdx}, settings);

    if strcmp(switch_capture, 'turn_on')
        % Extract Turn on
        returnWaveforms = turn_on_waveforms;
    else
        % Extract turn off
        returnWaveforms = turn_off_waveforms;
    end
end