%% Settings
if exist('SettingsFile', 'var')
    run(SettingsFile);
else
    run('SettingsDefault.m');
end

%% Setup
% Clear Matlab Workspace of any previous instrument connections
instrreset;
clear myScope;
clear myFGen;

% Setup Oscilloscope
myScope = SCPI_Oscilloscope(scopeVendor, scopeVisaAddress);
myScope.visaObj.InputBufferSize = Scope_Buffer_size;
myScope.visaObj.Timeout = scopeTimeout;
myScope.visaObj.ByteOrder = scopeByteOrder;

% Setup Function Generator
myFGen = SCPI_FunctionGenerator(FGenVendor, FGenVisaAddress);
myFGen.visaObj.InputBufferSize = FGen_buffer_size;
myFGen.visaObj.OutputBufferSize = FGen_buffer_size;

% Connect to devices
myScope.connect;
myFGen.connect;

% Reset to default state
myScope.reset;
myScope.clearStatus;
myFGen.reset;
myFGen.clearStatus;

%% Pulse Creation
% Find Function Generator Maximum Sample Rate
sampleRate = myFGen.getArbSampleRate(1, 'MAXimum');

% Setup CH1 Waveform
% Generate Double Pulse
[ch1_wave_points, total_time] = pulse_generator(sampleRate,... 
    pulse_lead_dead_t, pulse_first_pulse_t, pulse_off_t,... 
    pulse_second_pulse_t, pulse_end_dead_t);

% Load Waveform
myFGen.loadArbWaveform(ch1_wave_points, sampleRate, PeakValue, 'double_pulse', 1);

% Setup Burst
myFGen.setupBurst(burstMode, burstCycles, total_time, FGenTriggerSource, 1);

% Set Load
myFGen.setOutputLoad(1, 'INFinity');

% Setup CH2 Waveform
% Generate Single Pulse
[ch2_wave_points, total_time] = pulse_generator(sampleRate,...
    pulse_lead_dead_t + pulse_first_pulse_t + .1 * pulse_off_t,...
    .8 * pulse_off_t,...
    .1 * pulse_off_t + pulse_second_pulse_t + pulse_end_dead_t);

% Load Waveform
myFGen.loadArbWaveform(ch2_wave_points, sampleRate, PeakValue, 'single_pulse', 2);

% Setup Burst
myFGen.setupBurst(burstMode, burstCycles, total_time, FGenTriggerSource, 2);

% Set Load
myFGen.setOutputLoad(2, 'INFinity');

%% Pulse Measurement
% Ensure all Channels on
myScope.allChannelsOn;

% Turn Off Headers
myScope.removeHeaders;

% Set Scope Depended Properties
if myScope.scopeSeries == SCPI_Oscilloscope.Series5000
    % Set Horizontal Axis to maunal mode
    myScope.horizontalMode = 'MANual';
else
    % Set Data Resolution to Full
    myScope.dataResolution = 'FULL';
end

% Set scope sample rate and record length
myScope.sampleRate = scopeSampleRate;
myScope.recordLength = scopeRecordLength;

% Setup Probe Gains of neccessary
if myScope.scopeSeries == SCPI_Oscilloscope.Series4000
    myScope.ch1ProbeGain = ch1ProbeGain;
    myScope.ch2ProbeGain = ch2ProbeGain;
    myScope.ch3ProbeGain = ch3ProbeGain;
    myScope.ch4ProbeGain = ch4ProbeGain;
else
    % todo
end

% Set Initial Vertical Axis
myScope.ch1OffSet = ch1InitialOffset;
myScope.ch1Scale = ch1InitialScale;
myScope.ch2OffSet = ch2InitialOffset;
myScope.ch2Scale = ch2InitialScale;
myScope.ch3OffSet = ch3InitialOffset;
myScope.ch3Scale = ch3InitialScale;
myScope.ch4OffSet = ch4InitialOffset;
myScope.ch4Scale = ch4InitialScale;

% Set Initial Horizontal Axis
myScope.horizontalScale = horizontalScale;
myScope.horizontalDelayMode = delayMode;
myScope.horizontalPosition = horizontalPosition;

% Setup Trigger
myScope.setupTrigger(triggerType, triggerCoupling, triggerSlope,...
    triggerSource, triggerLevel);

% Setup Acquisition
myScope.acqMode = acquisitionMode;
myScope.acqStopAfter = acquisitionStop;
myScope.acqState = 'RUN';

pause(1);

% Trigger Waveform
myFGen.trigger;

% Setup binary data for the CURVE query
myScope.setupWaveformTransfer(numBytes, encoding);

% Get all four waveforms
WaveForms = cell(1, 4);

for idx = 1:4
    WaveForms{idx} = myScope.getWaveform(idx);
end

% Create Time Vector
period = 1 / myScope.sampleRate;
acq_time = myScope.recordLength * period;
t = 0:period:(acq_time - period);

% Plot
for idx = 1:4
    figure
    plot(t, WaveForms{idx});
end

% Rescale Oscilloscope
for idx = 1:4
    myScope.rescaleChannel(idx, WaveForms{idx}, numVerticalDivisions);
end

% Rerun Capture
myScope.acqState = 'RUN';

pause(1);

% Trigger Waveform
myFGen.trigger;

pause(1);

% Get all four waveforms
WaveForms = cell(1, 4);

for idx = 1:4
    WaveForms{idx} = myScope.getWaveform(idx);
end

% Plot
for idx = 1:4
    figure
    plot(t, WaveForms{idx})
end

% Disconnect from instruments
myScope.disconnect;
myFGen.disconnect;