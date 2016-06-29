classdef SCPI_Oscilloscope < SCPI_Instrument & handle
    %SCPI_Oscilloscope Oscilloscope Super Class for SCPI Controlled Scopes.
    %   The purpose of this super class is to allow code to be reused for
    %   multiple oscilloscopes that are controlled with SCPI commands. This
    %   class lays out the basic, general commands that will work with most
    %   oscilloscopes. Further subclasses for each instrument will allow
    %   for more specific control of each device. This class currently
    %   works as is for Tektronix 2000, 4000, and 5000 series scopes.
    
    properties (Constant)
        Series2000 = '2XXX'
        Series4000 = '4XXX'
        Series5000 = '5XXX'
    end
    
    properties
        %% Normal properties
        scopeSeries
        
        %% Command Strings
        % Acquisition Command Group
        % Alias Command
        % Bus Command Group
        % Calibration and Diagnostic Command Group
        % Cursor Command
        % Display Command
        % Ethernet Command
        % File System Command
        % FilterVu Command Group
        % Hard Copy Command
        % Horizontal Command Group
        recordLengthCommand
        sampleRateCommand
        horizontalScaleCommand
        % Mark Command
        % Math Command
        % Measurement Command
        % Miscellaneous Command
        % PictBridge Command Group
        % Save and Recall Command Group
        % Search Command
        % Status and Error Command
        % Trigger Command Group
        % Vertical Command
        % Waveform Transfer Command Group
        % Zoom Command
    end
   
    properties (Dependent)
        %% Group Properties
        % Acquisition Command Group
        acqMode
        acqStopAfter
        acqState
        acqSamplingMode
        % Alias Command
        % Bus Command Group
        % Calibration and Diagnostic Command Group
        % Cursor Command
        % Display Command
        % Ethernet Command
        % File System Command
        % FilterVu Command Group
        % Hard Copy Command
        % Horizontal Command Group
        recordLength
        sampleRate
        horizontalScale
        horizontalPosition
        horizontalMode
        horizontalDelayMode
        % Mark Command
        % Math Command
        % Measurement Command
        % Miscellaneous Command
        % PictBridge Command Group
        % Save and Recall Command Group
        % Search Command
        % Status and Error Command
        % Trigger Command Group
        % Vertical Command
        % Waveform Transfer Command Group
        dataStart
        dataStop
        dataResolution
        % Zoom Command
    end
    
    methods
        %% Super Overides
        function self = SCPI_Oscilloscope(visaVendor, visaAddress)
            self@SCPI_Instrument(visaVendor, visaAddress);
        end
        function connect(self)
            connect@SCPI_Instrument(self);
            self.setSeries;
        end
        %% Misc Methods
        function setSeries(self)
            % setSeries sets series for use with series specific commands
            %   Currently only works with Tektronix scopes.
            
            splitID = strsplit(self.identity, ',');
            vendor = splitID{1};
            model = splitID{2};
            
            Model_Digits = regexp(model, '\d', 'match');
            Model_Digit = Model_Digits{1};
            
            if strcmpi(vendor, 'TEKTRONIX')
                if Model_Digit == '5'
                    self.scopeSeries = SCPI_Oscilloscope.Series5000;
                elseif Model_Digit == '4'
                    self.scopeSeries = SCPI_Oscilloscope.Series4000;
                else
                    self.scopeSeries = SCPI_Oscilloscope.Series2000;
                end
            end
            
            self.setSeriesStr;
        end
        function setSeriesStr(self)
            if self.scopeSeries == SCPI_Oscilloscope.Series5000;
                self.recordLengthCommand = 'HORizontal:MODE:RECOrdlength';
                self.sampleRateCommand = 'HORizontal:MODE:SAMPLERate';
                self.horizontalScaleCommand = 'HORizontal:MODE:SCAle';
            else
                self.recordLengthCommand = 'HORizontal:RECOrdlength';
                self.sampleRateCommand = 'HORizontal:SAMPLERate';
                self.horizontalScaleCommand = 'HORizontal:SCAle';
            end
        end
        function allChannelsOn(self)
            self.channelsOn([1, 2, 3, 4]);
        end
        function allChannelsOff(self)
            self.channelsOff([1, 2, 3, 4]);
        end
        function channelsOn(self, channels)
            for channel = channels
                channelStr = self.U2Str(channel);
                self.sendCommand(['SELECT:CH' channelStr ' ON']);
            end
        end
        function channelsOff(self, channels)
            for channel = channels
                channelStr = self.U2Str(channel);
                self.sendCommand(['SELECT:CH' channelStr ' OFF']);
            end
        end
        function out = isChannelOn(self, channel)
            channelStr = self.U2Str(channel);
            out = logical(str2double(self.query(['SELECT:CH' channelStr '?'])));
        end
        function channelStates = getChannelsState(self)
            tempChannelStates = [0, 0, 0, 0];
            for i = 1:4
                tempChannelStates(i) = self.isChannelOn(i);
            end
            
            channelStates = tempChannelStates;
        end
        function setupTrigger(self, triggerType, coupling, slope, source, level)
            % setupTrigger sets up oscilloscope trigger currently only
            % works with edge trigger
            %   Args: (triggerType, coupling, slope, source, level)
            %   triggerType: trigger type {EDGe|LOGic|PULSe|BUS|VIDeo}
            %   coupling: Trigger Coupling {DC|HFRej|LFRej|NOISErej}
            %   slope: Trigger Slope {RISe|FALL}
            %   source: Trigger Source (int) {1-4}
            %   level: Trigger Level (double)
            
            self.sendCommand(['TRIGger:A:TYPe ' triggerType]);
            self.sendCommand(['TRIGger:A:EDGE:COUPling ' coupling]);
            self.sendCommand(['TRIGger:A:EDGE:SLOpe ' slope]);
            self.sendCommand(['TRIGger:A:EDGE:SOUrce CH' num2str(source)]);
            self.sendCommand(['TRIGger:A:LEVel:CH1 ' num2str(level)]);
        end
        function setupWaveformTransfer(self, numBytes, encoding)
            % setupWaveformTransfer sets binary format for waverform.
            %   Args: (numBytes, encoding)
            %   numBytes: Number of bytes to use to send waveform points.
            %   must be 1 or 2.
            %   encoding: Encoding scheme to use with binary data, see
            %   programming manual for acceptable values and descriptions.
            numBits = 8 * numBytes;
            numBits = int2str(numBits);
            numBytes = int2str(numBytes);
            self.sendCommand(['WFMOutpre:BIT_Nr ' numBits]);
            self.sendCommand(['DATa:ENCdg ' encoding]);
            self.sendCommand(['WFMOutpre:BYT_Nr ' numBytes]);
            self.sendCommand(['DATa:WIDth ' numBytes]);
        end
        function waveform = getWaveform(self, channel)
            % getWaveform gets one channels waveform from scope
            % setupWaveformTransfer should be called first.
            %   Args: (channel)
            %   channel: Channel to get waveform from (1-4)
            
            scopeBufferSize = self.visaObj.InputBufferSize;
            numBytes = self.numQuery('WFMOutpre:BYT_Nr?');
            
            % Set Waveform Source
            curChannel = ['CH' int2str(channel)];
            self.sendCommand(['DATa:SOURce ' curChannel]);

            % Grab waveform in pieces to keep buffer size low
            num_pieces = ceil((self.recordLength * numBytes) / scopeBufferSize);
            start_pieces = [1 scopeBufferSize/numBytes+1:scopeBufferSize/numBytes:scopeBufferSize/numBytes*num_pieces];
            stop_pieces = scopeBufferSize/numBytes:scopeBufferSize/numBytes:scopeBufferSize/numBytes*num_pieces;
            if stop_pieces(end) < self.recordLength
                stop_pieces = [stop_pieces self.recordLength];
            elseif stop_pieces(end) > self.recordLength
                stop_pieces(end) = self.recordLength;
            end

            value = zeros(1, self.recordLength);

            for j = 1:num_pieces
                % Ensure that the start and stop values for CURVE query match the full
                % record length
                self.sendCommand(['DATA:START ' num2str(start_pieces(j))]);
                self.sendCommand(['DATA:STOP ' num2str(stop_pieces(j))]);

                % Request the CURVE
                % Read the captured data as 8-bit integer data type
                if numBytes == 1
                    precision = 'int8';
                else
                    precision = 'int16';
                end
                jvalue = self.binBlockQuery('CURVE?', precision);

                value(start_pieces(j):stop_pieces(j)) = jvalue;
            end

            % Scale Data
            YOFf_in_dl = self.numQuery('WFMO:YOF?');
            YMUlt = self.numQuery('WFMO:YMUL?');
            YZEro_in_units = self.numQuery('WFMO:YZE?');
            value_in_units = ((value - YOFf_in_dl) * YMUlt) + YZEro_in_units;
            
            % Return
            waveform = value_in_units;
        end
        function rescaleChannel(self, channel, waveform, numDivisions, percentBuffer)
            % rescaleChannel Rescales channel to give full range of values.
            % Based on supplied waveform.
            %   Args: (channel, waveform, numDivisions)
            %   channel: Channel to rescale
            %   waveform: Waveform vector containing channel's waveform
            %   numDivisions: Number of divisions on oscilloscope screen
            %   percentBuffer: Integer percent buffer to increase scale by
            %   adds percentBuffer / 2 to top and bottom.
            
            self.minMaxRescaleChannel(channel, min(waveform),...
                max(waveform), numDivisions, percentBuffer);
        end 
        function minMaxRescaleChannel(self, channel, minValue, maxValue, numDivisions, percentBuffer)
            % minMaxRescaleChannel Rescales channel to give full range of
            % values. Based on supplied minimum and maximum values.
            %   Args: (channel, minValue, maxValue, waveform, numDivisions, percentBuffer)
            %   channel: Channel to rescale
            %   minValue: Minimum value to be displayed on Oscilloscope
            %   maxValue: Maximum Value to be displayed on Oscilloscope
            %   numDivisions: Number of divisions on oscilloscope screen
            %   percentBuffer: Integer percent buffer to increase scale by
            %   adds percentBuffer / 2 to top and bottom.
            curChannel = ['CH' int2str(channel)];
            data_range = maxValue - minValue;
            new_scale = (data_range / numDivisions);
            new_y_pos = ((min(waveform)/new_scale) + (numDivisions / 2));
            new_scale = new_scale * (1 + percentBuffer / 100);
            new_y_pos = new_y_pos * (1 - percentBuffer / 100);
            self.sendCommand([curChannel ':SCAle ' num2str(new_scale)]);
            self.sendCommand([curChannel ':POSition ' num2str(-new_y_pos)]);
        end
        % Channel Probe Gain   
        function setChProbeGain(self, channel, chProbeGain)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':PRObe:GAIN ' num2str(chProbeGain)]);
        end
        function chProbeGain = getChProbeGain(self, channel)
            channel = self.U2Str(channel);
            chProbeGain = str2double(self.query(['CH' channel ':PRObe:GAIN?']));
        end
        % Channel Offset
        function setChOffSet(self, channel, chOffSet)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':OFFSet ' num2str(chOffSet)]);
        end
        function chOffSet = getChOffSet(self, channel)
            channel = self.U2Str(channel);
            chOffSet = str2double(self.query(['CH' channel ':OFFSet?']));
        end
        % Channel Scale
        function setChScale(self, channel, chScale)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':SCAle ' num2str(chScale)]);
        end
        function chScale = getChScale(self, channel)
            channel = self.U2Str(channel);
            chScale = str2double(self.query(['CH' channel ':SCAle?']));
        end
        % Channel Position
        function setChPosition(self, channel, chPosition)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':POSition ' num2str(chPosition)]);
        end
        function chPosition = getChPosition(self, channel)
            channel = self.U2Str(channel);
            chPosition = str2double(self.query(['CH' channel ':POSition?']));
        end      
        % Channel Deskew
        function setChDeskew(self, channel, chDeskew)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':DESKew ' num2str(chDeskew)]);
        end
        function chDeskew = getChDeskew(self, channel)
            channel = self.U2Str(channel);
            chDeskew = str2double(self.query(['CH' channel ':DESKew?']));
        end    
        % Channel Termination
        function setChTermination(self, channel, chTermination)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':TERmination ' num2str(chTermination)]);
        end
        function chTermination = getChTermination(self, channel)
            channel = self.U2Str(channel);
            chTermination = str2double(self.query(['CH' channel ':TERmination?']));
        end    
        % Channel Degauss State
        function chDeskew = getChDegaussState(self, channel)
            channel = self.U2Str(channel);
            chDeskew = str2double(self.query(['CH' channel ':DESKew?']));
        end   
        % Channel Invert
        % chInvert is 'ON' or 'OFF'
        function setChInvert(self, channel, chInvert)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':INVert ' chInvert]);
        end
        function chInvert = getChInvert(self, channel)
            channel = self.U2Str(channel);
            chInvert = self.query(['CH' channel ':INVert?']);
        end
        % Channel Probe Forced Range
        function setChProbeForcedRange(self, channel, chForcedRange)
            channel = self.U2Str(channel);
            chForcedRange = self.U2Str(chForcedRange);
            self.sendCommand(['CH' channel ':PRObe:FORCEDRange ' chForcedRange]);
        end
        function chForcedRange = getProbeForcedRange(self, channel)
            channel = self.U2Str(channel);
            chForcedRange = str2double(self.query(['CH' channel ':PRObe:FORCEDRange?']));
        end
        % Channel Probe Control
        % Acceptable values for probeControl {AUTO|MANual}
        function setChProbeControl(self, channel, chProbeControl)
            channel = self.U2Str(channel);
            chProbeControl = self.U2Str(chProbeControl);
            self.sendCommand(['CH' channel ':PROBECOntrol ' chProbeControl]);
        end
        function chProbeControl = getProbeForcedControl(self, channel)
            channel = self.U2Str(channel);
            chProbeControl = str2double(self.query(['CH' channel ':PROBECOntrol?']));
        end
        % Channel Label Name
        function setChLabelName(self, channel, chLabel)
            channel = self.U2Str(channel);
            self.sendCommand(['CH' channel ':LABel:NAMe "' chLabel '"']);
        end
        function chLabel = getChLabelName(self, channel)
            channel = self.U2Str(channel);
            chLabelQuoted = self.query(['CH' channel ':LABel:NAMe?']);
            chLabel = chLabelQuoted(2:end-1);
        end
        % Channel External Attenuation
        function setChExtAtten(self, channel, chExtAtten)
            if strcmp(self.scopeSeries, SCPI_Oscilloscope.Series5000)
                channel = self.U2Str(channel);
                self.sendCommand(['CH' channel ':PROBEFunc:EXTAtten ' num2str(chExtAtten)]);
            else
                warning('External Attentuation not supported for this scope');
            end
        end
        function chExtAtten = getChExtAtten(self, channel)
            if strcmp(self.scopeSeries, SCPI_Oscilloscope.Series5000)
                channel = self.U2Str(channel);
                chExtAtten = str2double(self.query(['CH' channel ':PROBEFunc:EXTAtten?']));
            else
                warning('External Attentuation not supported for this scope');
            end
        end
        % Channel External Attenuation Units
        function setChExtAttenUnits(self, channel, chExtAttenUnits)
            if strcmp(self.scopeSeries, SCPI_Oscilloscope.Series5000)
                channel = self.U2Str(channel);
                self.sendCommand(['CH' channel ':PROBEFunc:EXTUnits "' chExtAttenUnits '"']);
            else
                warning('External Attentuation not supported for this scope');
            end
        end
        function chExtAttenUnits = getChExtAttenUnits(self, channel)
            if strcmp(self.scopeSeries, SCPI_Oscilloscope.Series5000)
                channel = self.U2Str(channel);
                chExtAttenUnitsQuoted = self.query(['CH' channel ':PROBEFunc:EXTUnits?']);
                chExtAttenUnits = chExtAttenUnitsQuoted(2:end-1); % Strip Quotes
            else
                warning('External Attentuation not supported for this scope');
            end
        end
        
        %% Property Getter and Setter Commands
        % Template
%         function set.[property](self, [property])
%             [property] = self.U2Str([property]);
%             self.sendCommand(['[command] ' [property]]);
%         end
%         function [property] = get.[property](self)
%             [property] = str2double(self.query('[command]?'));
%         end
        
        % Acquisition Command Group
        function set.acqMode(self, acqMode)
            self.sendCommand(['ACQuire:MODe ' num2str(acqMode)]);
        end
        function acqMode = get.acqMode(self)
            acqMode = str2double(self.query('ACQuire:MODe?'));
        end
        function set.acqStopAfter(self, acqStopAfter)
            self.sendCommand(['ACQuire:STOPAfter ' num2str(acqStopAfter)]);
        end
        function acqStopAfter = get.acqStopAfter(self)
            acqStopAfter = str2double(self.query('ACQuire:STOPAfter?'));
        end
        function set.acqState(self, acqState)
            self.sendCommand(['ACQuire:STATE ' num2str(acqState)]);
        end
        function acqState = get.acqState(self)
            acqState = str2double(self.query('ACQuire:STATE?'));
        end
        function set.acqSamplingMode(self, acqSamplingMode)
            % Acceptable acqSamplingMode values: {RT|ET|IT}
            self.sendCommand(['ACQuire:SAMPlingmode ' acqSamplingMode]);
        end
        function acqSamplingMode = get.acqSamplingMode(self)
            acqSamplingMode = self.query('ACQuire:SAMPlingmode?');
        end        
        % Alias Command
        % Bus Command Group
        % Calibration and Diagnostic Command Group
        % Cursor Command
        % Display Command
        % Ethernet Command
        % File System Command
        % FilterVu Command Group
        % Hard Copy Command
        % Horizontal Command Group
        function set.recordLength(self, length)
            self.sendCommand([self.recordLengthCommand ' ' int2str(length)]);
        end
        function length = get.recordLength(self)
            length = str2double(self.query([self.recordLengthCommand '?']));
        end
        function set.sampleRate(self, sampleRate)
            self.sendCommand([self.sampleRateCommand ' ' num2str(sampleRate)]);
        end
        function sampleRate = get.sampleRate(self)
            sampleRate = str2double(self.query([self.sampleRateCommand '?']));
        end
        function set.horizontalScale(self, horizontalScale)
            self.sendCommand([self.horizontalScaleCommand ' ' num2str(horizontalScale)]);
        end
        function horizontalScale = get.horizontalScale(self)
            horizontalScale = str2double(self.query([self.horizontalScaleCommand '?']));
        end
        function set.horizontalPosition(self, horizontalPosition)
            self.sendCommand(['HORizontal:POSition ' num2str(horizontalPosition)]);
        end
        function horizontalPosition = get.horizontalPosition(self)
            horizontalPosition = str2double(self.query('HORizontal:POSition?'));
        end
        function set.horizontalMode(self, horizontalMode)
            self.sendCommand(['HORizontal:MODE ' num2str(horizontalMode)]);
        end
        function horizontalMode = get.horizontalMode(self)
            horizontalMode = str2double(self.query('HORizontal:MODE?'));
        end    
        function set.horizontalDelayMode(self, horizontalDelayMode)
            self.sendCommand(['HORizontal:DELay:MODe ' num2str(horizontalDelayMode)]);
        end
        function horizontalDelayMode = get.horizontalDelayMode(self)
            horizontalDelayMode = str2double(self.query('HORizontal:DELay:MODe?'));
        end
        % Mark Command
        % Math Command
        % Measurement Command
        % Miscellaneous Command
        function removeHeaders(self)
            self.sendCommand('HEADer OFF');
        end
        % PictBridge Command Group
        % Save and Recall Command Group
        % Search Command
        % Status and Error Command
        % Trigger Command Group
        % Vertical Command Group       
        % Waveform Transfer Command Group
        function set.dataStart(self, start)
            self.sendCommand(['DATa:STARt ' int2str(start)]);
        end
        function start = get.dataStart(self)
            start = str2double(self.query('DATa:STARt?'));
        end
        function set.dataStop(self, stop)
            self.sendCommand(['DATa:STOP ' int2str(stop)]);
        end
        function stop = get.dataStop(self)
            stop = str2double(self.query('DATa:STOP?'));
        end
        function set.dataResolution(self, dataResolution)
            self.sendCommand(['DATa:RESOlution ' num2str(dataResolution)]);
        end
        function dataResolution = get.dataResolution(self)
            dataResolution = str2double(self.query('DATa:RESOlution?'));
        end        
        % Zoom Command Group
    end
end

