%% Setup
% Clear Matlab Workspace of any previous instrument connections
instrreset;
clear myScope;
clear myFGen;

% Define constants
FGen_buffer_size = 6000000;
Scope_Buffer_size = 200000;

% Set VISA Resource Strings
scopeVisaAddress = 'USB::0x0699::0x0502::C051196::INSTR';
FGenVisaAddress = 'USB::0x0957::0x2307::MY50000715::INSTR';

% Set Vendor Strings
scopeVendor = 'tek';
FGenVendor = 'agilent';

% Setup Oscilloscope
myScope = SCPI_Instrument(scopeVendor, scopeVisaAddress);
myScope.visaObj.InputBufferSize = Scope_Buffer_size;
myScope.visaObj.Timeout = 10;
myScope.visaObj.ByteOrder = 'littleEndian';

% Setup Function Generator
myFGen = SCPI_Instrument(FGenVendor, FGenVisaAddress);
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
% Setup CH1 ARB Waveform
PeakValue = 1;
pulse_lead_dead_t = 10e-6;
pulse_first_pulse_t = 30e-6;
pulse_off_t = 15e-6;
pulse_second_pulse_t = 10e-6;
pulse_end_dead_t = 10e-6;

[ch1_wave_points, sample_rate, total_time] = double_pulse_generator(pulse_lead_dead_t, pulse_first_pulse_t, pulse_off_t, pulse_second_pulse_t, pulse_end_dead_t);

strDataCH1 = sprintf('%d, ', ch1_wave_points);
strDataCH1 = strDataCH1(1:end-2);

myFGen.sendCommand('SOURce1:FUNCtion ARB');
myFGen.sendCommand(['SOURce1:FUNC:ARB:SRATE ' int2str(sample_rate)]);
myFGen.sendCommand('SOURce1:FUNC:ARB:FILTER STEP');
myFGen.sendCommand(['SOURce1:FUNC:ARB:PTPEAK ' num2str(PeakValue)]);

myFGen.sendCommand(['SOURce1:DATA:ARB double_pulse, ' strDataCH1]);
myFGen.sendCommand('SOURce1:FUNC:ARB double_pulse');

% Setup Burst
myFGen.sendCommand('SOURce1:BURSt:MODE TRIGgered');
myFGen.sendCommand('SOURce1:BURSt:NCYCles 1' );
myFGen.sendCommand(['SOURce1:BURSt:INTernal:PERiod ' num2str(total_time * 1.1)]);
myFGen.sendCommand('TRIGger1:SOURce BUS');
myFGen.sendCommand('SOURce1:BURSt:STATe ON');
myFGen.sendCommand('OUTPut1 ON');

% Setup CH2 Waveform
[ch2_wave_points, sample_rate, total_time] = single_pulse_generator(pulse_lead_dead_t + pulse_first_pulse_t + .1 * pulse_off_t, .8 * pulse_off_t, .1 * pulse_off_t + pulse_second_pulse_t + pulse_end_dead_t);

strDataCH2 = sprintf('%d, ', ch2_wave_points);
strDataCH2 = strDataCH2(1:end-2);

myFGen.sendCommand('SOURce2:FUNCtion ARB');
myFGen.sendCommand(['SOURce2:FUNC:ARB:SRATE ' int2str(sample_rate)]);
myFGen.sendCommand('SOURce2:FUNC:ARB:FILTER STEP');
myFGen.sendCommand(['SOURce2:FUNC:ARB:PTPEAK ' num2str(PeakValue)]);

myFGen.sendCommand(['SOURce2:DATA:ARB single_pulse, ' strDataCH2]);
myFGen.sendCommand('SOURce2:FUNC:ARB single_pulse');

% Setup Burst
myFGen.sendCommand('SOURce2:BURSt:MODE TRIGgered');
myFGen.sendCommand('SOURce2:BURSt:NCYCles 1' );
myFGen.sendCommand(['SOURce2:BURSt:INTernal:PERiod ' num2str(total_time * 1.1)]);
myFGen.sendCommand('TRIGger2:SOURce BUS');
myFGen.sendCommand('SOURce2:BURSt:STATe ON');
myFGen.sendCommand('OUTPut2 ON');

%% Pulse Measurement
% Ensure all Channels on
myScope.sendCommand('SELECT:CH1 ON');
myScope.sendCommand('SELECT:CH2 ON');
myScope.sendCommand('SELECT:CH3 ON');
myScope.sendCommand('SELECT:CH4 ON');
% Turn headers off, this makes parsing easier
myScope.sendCommand('HEADer OFF');

% Get record length value
% myScope.sendCommand('DATa:RESOlution FULL')
myScope.sendCommand('HORizontal:MODE MANual');
myScope.sendCommand('HORizontal:MODE:SAMPLERate 10E9');
myScope.sendCommand('HOR:MODE:RECO 1000000');
recordLengthStr = myScope.query('HOR:MODE:RECO?');
recordLength = str2double(recordLengthStr);

% Setup Probe
% myScope.sendCommand('CH1:PRObe:GAIN 1');
% myScope.sendCommand('CH2:PRObe:GAIN 1');
% myScope.sendCommand('CH3:PRObe:GAIN 1');
% myScope.sendCommand('CH4:PRObe:GAIN 1');

% Setup Y-Axis
myScope.sendCommand('CH1:OFFSet 0');
myScope.sendCommand('CH1:SCAle .3');
myScope.sendCommand('CH2:OFFSet 0');
myScope.sendCommand('CH2:SCAle .3');
myScope.sendCommand('CH3:OFFSet 0');
myScope.sendCommand('CH3:SCAle 5');
myScope.sendCommand('CH4:OFFSet 0');
myScope.sendCommand('CH4:SCAle 5');

% Setup X-Axis
myScope.sendCommand('HORizontal:MODE:SCAle 20e-6');
myScope.sendCommand('HORizontal:DELay:MODe OFF');
myScope.sendCommand('HORizontal:POSition 25');

% Setup Trigger
myScope.sendCommand('TRIGger:A:TYPe EDGe');
myScope.sendCommand('TRIGger:A:EDGE:COUPling DC');
myScope.sendCommand('TRIGger:A:EDGE:SLOpe RISe');
myScope.sendCommand('TRIGger:A:EDGE:SOUrce CH1');
myScope.sendCommand('TRIGger:A:LEVel:CH1 0.5');

% Setup Acquisition
myScope.sendCommand('ACQuire:MODe HIRes');
myScope.sendCommand('ACQuire:STOPAfter SEQuence');
myScope.sendCommand('ACQuire:STATE RUN');

pause(1);

% Trigger Waveform
myFGen.sendCommand('*TRG;*WAI');


% Request 8 bit binary data on the CURVE query
myScope.sendCommand('WFMO:BIT_N 16');
myScope.sendCommand('DATA:ENCDG SRI');
myScope.sendCommand('WFMOutpre:BYT_Nr 2');
myScope.sendCommand('DATa:WIDth 2');

WaveForms = cell(1, 4);

for idx = 1:4
    % Set Waveform Source
    curChannel = ['CH' int2str(idx)];
    myScope.sendCommand(['DATa:SOURce ' curChannel]);
    
    % Grab waveform in pieces to keep buffer size low
    num_pieces = ceil((recordLength * 2) / Scope_Buffer_size);
    start_pieces = [1 Scope_Buffer_size/2+1:Scope_Buffer_size/2:Scope_Buffer_size/2*num_pieces];
    stop_pieces = [Scope_Buffer_size/2:Scope_Buffer_size/2:Scope_Buffer_size/2*num_pieces recordLength];
    
    value = [];
    
    for j = 1:num_pieces
        % Ensure that the start and stop values for CURVE query match the full
        % record length
        myScope.sendCommand(['DATA:START ' num2str(start_pieces(j))]);
        myScope.sendCommand(['DATA:STOP ' num2str(stop_pieces(j))]);

        % Request the CURVE
        % Read the captured data as 8-bit integer data type
        jvalue = myScope.binBlockQuery('CURVE?', 'int16');
        
        value = [value 
                jvalue];
    end
    
    % Scale Data
    YOFf_in_dl = myScope.numQuery('WFMO:YOF?');
    YMUlt = myScope.numQuery('WFMO:YMUL?');
    YZEro_in_units = myScope.numQuery('WFMO:YZE?');
    value_in_units = ((value - YOFf_in_dl) * YMUlt) + YZEro_in_units;
    
    % Store Data in Cell
    WaveForms{idx} = value_in_units;
end

% Create Time Vector
scope_sample_rate = myScope.numQuery('HORizontal:MODE:SAMPLERate?');
period = 1 / scope_sample_rate;
num_samples = str2double(recordLengthStr);
acq_time = num_samples * period;
t = 0:period:(acq_time - period);

% Plot
for idx = 1:4
    figure
    plot(t, WaveForms{idx});
end

% Rescale Oscilloscope
for idx = 1:4
    curChannel = ['CH' int2str(idx)];
    data_range = max(WaveForms{idx}) - min(WaveForms{idx});
    new_scale = data_range / 10;
    % new_y_offset = (-new_scale * 4) - min(value_in_units);
    new_y_pos = (min(WaveForms{idx})/new_scale) + 5;
    myScope.sendCommand([curChannel ':SCAle ' num2str(new_scale)]);
    myScope.sendCommand([curChannel ':POSition -' num2str(new_y_pos)]);
end

% Rerun Capture
myScope.sendCommand('ACQuire:STATE RUN');

pause(1);

% Trigger Waveform
myFGen.sendCommand('*TRG;*WAI');

pause(1);

for idx = 1:4
    % Set Waveform Source
    curChannel = ['CH' int2str(idx)];
    myScope.sendCommand(['DATa:SOURce ' curChannel]);
    
    % Grab waveform in pieces to keep buffer size low
    num_pieces = ceil((recordLength * 2) / Scope_Buffer_size);
    start_pieces = [1 Scope_Buffer_size/2+1:Scope_Buffer_size/2:Scope_Buffer_size/2*num_pieces];
    stop_pieces = [Scope_Buffer_size/2:Scope_Buffer_size/2:Scope_Buffer_size/2*num_pieces recordLength];
    
    value = [];
    
    for j = 1:num_pieces
        % Ensure that the start and stop values for CURVE query match the full
        % record length
        myScope.sendCommand(['DATA:START ' num2str(start_pieces(j))]);
        myScope.sendCommand(['DATA:STOP ' num2str(stop_pieces(j))]);

        % Request the CURVE
        % Read the captured data as 8-bit integer data type
        jvalue = myScope.binBlockQuery('CURVE?', 'int16');
        
        value = [value 
                jvalue];
    end
    
    % Scale Data
    YOFf_in_dl = myScope.numQuery('WFMO:YOF?');
    YMUlt = myScope.numQuery('WFMO:YMUL?');
    YZEro_in_units = myScope.numQuery('WFMO:YZE?');
    value_in_units = ((value - YOFf_in_dl) * YMUlt) + YZEro_in_units;
    
    % Store Data in Cell
    WaveForms{idx} = value_in_units;
end

% Create Time Vector
scope_sample_rate = myScope.numQuery('HORizontal:MODE:SAMPLERate?');
period = 1 / scope_sample_rate;
num_samples = str2double(recordLengthStr);
acq_time = num_samples * period;
t = 0:period:(acq_time - period);

for idx = 1:4
    figure
    plot(t, WaveForms{idx})
end

myScope.disconnect;
myFGen.disconnect;
