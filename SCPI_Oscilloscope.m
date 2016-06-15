

classdef SCPI_Oscilloscope < SCPI_Instrument & handle
    %SCPI_Oscilloscope Oscilloscope Super Class for SCPI Controlled Scopes.
    %   The purpose of this super class is to allow code to be reused for
    %   multiple oscilloscopes that are controlled with SCPI commands. This
    %   class lays out the basic, general commands that will work with most
    %   oscilloscopes. Further subclasses for each instrument will allow
    %   for more specific control of each device.
    
    properties (Constant)
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
        ch1ProbeGain
        ch1OffSet
        ch1Scale
        ch2ProbeGain
        ch2OffSet
        ch2Scale
        ch3ProbeGain
        ch3OffSet
        ch3Scale
        ch4ProbeGain
        ch4OffSet
        ch4Scale
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
            splitID = strsplit(self.identity, ',');
            model = splitID{2};
            
            Model_Digits = regexp(model, '\d', 'match');
            Model_Digit = Model_Digits{1};
            
            if Model_Digit == '5'
                self.scopeSeries = SCPI_Oscilloscope.Series5000;
            else
                self.scopeSeries = SCPI_Oscilloscope.Series4000;
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
            self.sendCommand('SELECT:CH1 ON');
            self.sendCommand('SELECT:CH2 ON');
            self.sendCommand('SELECT:CH3 ON');
            self.sendCommand('SELECT:CH4 ON');
        end
        function setupTrigger(self, triggerType, coupling, slope, source, level)
            self.sendCommand(['TRIGger:A:TYPe ' triggerType]);
            self.sendCommand(['TRIGger:A:EDGE:COUPling ' coupling]);
            self.sendCommand(['TRIGger:A:EDGE:SLOpe ' slope]);
            self.sendCommand(['TRIGger:A:EDGE:SOUrce CH' num2str(source)]);
            self.sendCommand(['TRIGger:A:LEVel:CH1 ' num2str(level)]);
        end
        function setupWaveformTransfer(self, numBytes, encoding)
            numBits = 8 * numBytes;
            numBits = int2str(numBits);
            numBytes = int2str(numBytes);
            self.sendCommand(['WFMO:BIT_N ' numBits]);
            self.sendCommand(['DATA:ENCDG ' encoding]);
            self.sendCommand(['WFMOutpre:BYT_Nr ' numBytes]);
            self.sendCommand(['DATa:WIDth ' numBytes]);
        end
        function waveform = getWaveform(self, channel)
            scopeBufferSize = self.visaObj.InputBufferSize;
            numBytes = self.numQuery('WFMOutpre:BYT_Nr?');
            
            % Set Waveform Source
            curChannel = ['CH' int2str(channel)];
            self.sendCommand(['DATa:SOURce ' curChannel]);

            % Grab waveform in pieces to keep buffer size low
            num_pieces = ceil((self.recordLength * numBytes) / scopeBufferSize);
            start_pieces = [1 scopeBufferSize/numBytes+1:scopeBufferSize/numBytes:scopeBufferSize/numBytes*num_pieces];
            stop_pieces = [scopeBufferSize/numBytes:scopeBufferSize/numBytes:scopeBufferSize/numBytes*num_pieces self.recordLength];

            value = [];

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

                value = [value 
                        jvalue];
            end

            % Scale Data
            YOFf_in_dl = self.numQuery('WFMO:YOF?');
            YMUlt = self.numQuery('WFMO:YMUL?');
            YZEro_in_units = self.numQuery('WFMO:YZE?');
            value_in_units = ((value - YOFf_in_dl) * YMUlt) + YZEro_in_units;
            
            % Return
            waveform = value_in_units;
        end
        function rescaleChannel(self, channel, waveform, numDivisions)
            curChannel = ['CH' int2str(channel)];
            data_range = max(waveform) - min(waveform);
            new_scale = data_range / numDivisions;
            new_y_pos = (min(waveform)/new_scale) + (numDivisions / 2);
            self.sendCommand([curChannel ':SCAle ' num2str(new_scale)]);
            self.sendCommand([curChannel ':POSition -' num2str(new_y_pos)]);
        end        
        
        %% Getter and Setter Commands
        % Template
%         function set.[property](self, [property])
%             self.sendCommand(['[command] ' num2str([property])]);
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
            self.sendCommand([length ' ' int2str(length)]);
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
        %   Channel1
        %       Probe Gain
        function set.ch1ProbeGain(self, ch1ProbeGain)
            self.sendCommand(['CH1:PRObe:GAIN ' num2str(ch1ProbeGain)]);
        end
        function ch1ProbeGain = get.ch1ProbeGain(self)
            ch1ProbeGain = str2double(self.query('CH1:PRObe:GAIN?'));
        end
        %       Offset
        function set.ch1OffSet(self, ch1OffSet)
            self.sendCommand(['CH1:OFFSet ' num2str(ch1OffSet)]);
        end
        function ch1OffSet = get.ch1OffSet(self)
            ch1OffSet = str2double(self.query('CH1:OFFSet?'));
        end
        %       Scale
        function set.ch1Scale(self, ch1Scale)
            self.sendCommand(['CH1:SCAle ' num2str(ch1Scale)]);
        end
        function ch1Scale = get.ch1Scale(self)
            ch1Scale = str2double(self.query('CH1:SCAle?'));
        end
        %   Channel2
        %       Probe Gain
        function set.ch2ProbeGain(self, ch2ProbeGain)
            self.sendCommand(['CH2:PRObe:GAIN ' num2str(ch2ProbeGain)]);
        end
        function ch2ProbeGain = get.ch2ProbeGain(self)
            ch2ProbeGain = str2double(self.query('CH2:PRObe:GAIN?'));
        end
        %       Offset
        function set.ch2OffSet(self, ch2OffSet)
            self.sendCommand(['CH2:OFFSet ' num2str(ch2OffSet)]);
        end
        function ch2OffSet = get.ch2OffSet(self)
            ch2OffSet = str2double(self.query('CH2:OFFSet?'));
        end
        %       Scale
        function set.ch2Scale(self, ch2Scale)
            self.sendCommand(['CH2:SCAle ' num2str(ch2Scale)]);
        end
        function ch2Scale = get.ch2Scale(self)
            ch2Scale = str2double(self.query('CH2:SCAle?'));
        end
        %   Channel3
        %       Probe Gain
        function set.ch3ProbeGain(self, ch3ProbeGain)
            self.sendCommand(['CH3:PRObe:GAIN ' num2str(ch3ProbeGain)]);
        end
        function ch3ProbeGain = get.ch3ProbeGain(self)
            ch3ProbeGain = str3double(self.query('CH3:PRObe:GAIN?'));
        end
        %       Offset
        function set.ch3OffSet(self, ch3OffSet)
            self.sendCommand(['CH3:OFFSet ' num2str(ch3OffSet)]);
        end
        function ch3OffSet = get.ch3OffSet(self)
            ch3OffSet = str3double(self.query('CH3:OFFSet?'));
        end
        %       Scale
        function set.ch3Scale(self, ch3Scale)
            self.sendCommand(['CH3:SCAle ' num2str(ch3Scale)]);
        end
        function ch3Scale = get.ch3Scale(self)
            ch3Scale = str3double(self.query('CH3:SCAle?'));
        end
        %   Channel4
        %       Probe Gain
        function set.ch4ProbeGain(self, ch4ProbeGain)
            self.sendCommand(['CH4:PRObe:GAIN ' num2str(ch4ProbeGain)]);
        end
        function ch4ProbeGain = get.ch4ProbeGain(self)
            ch4ProbeGain = str4double(self.query('CH4:PRObe:GAIN?'));
        end
        %       Offset
        function set.ch4OffSet(self, ch4OffSet)
            self.sendCommand(['CH4:OFFSet ' num2str(ch4OffSet)]);
        end
        function ch4OffSet = get.ch4OffSet(self)
            ch4OffSet = str4double(self.query('CH4:OFFSet?'));
        end
        %       Scale
        function set.ch4Scale(self, ch4Scale)
            self.sendCommand(['CH4:SCAle ' num2str(ch4Scale)]);
        end
        function ch4Scale = get.ch4Scale(self)
            ch4Scale = str4double(self.query('CH4:SCAle?'));
        end
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

