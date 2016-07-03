classdef GeneralWaveform < handle
    %GeneralWaveform Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        NOT_RECORDED = -102;
    end    
    
    properties
        % Waveforms
        v_ds
        v_gs
        i_d
        i_l
        time
        
        % Capture Channels
        channel@channelMapper
        
        % Capture Channels Cell
        channelOrderedCell
    end
    
    properties (Dependent)
        samplePeriod
        sampleRate
    end  
    
    methods
        function self = GeneralWaveform(v_ds, v_gs, i_d, i_l, time)
            if nargin == 2
                % Create Object from
            elseif nargin > 0
                % Assign values
                self.v_ds = v_ds;
                self.v_gs = v_gs;
                self.i_d = i_d;
                self.i_l = i_l;
                self.time = time;
                
                % Instantiate empty channels and Cell
                self.channel = channelMapper;
                self.channelOrderedCell = {};
            end
        end
        function sampleRate = get.sampleRate(self)
            % Sample Rate is the inverse of sample period
            sampleRate = 1 / self.samplePeriod;
        end
        function samplePeriod = get.samplePeriod(self)
            % Sample Rate is the inverse of sample period
            samplePeriod = self.time(2) - self.time(1);
        end
        function chCell = get.channelOrderedCell(self)
            % Check if cell has been created
            if ~isempty(self.channelOrderedCell)
                chCell = self.channelOrderedCell;
            else
                chCell = self.NOT_RECORDED;
            end
        end
    end
    
    methods (Static)
        % Class Methods
        % Create object from oscilloscope output
        function GW = fromChannelCell(class, waveforms, channels)
            % Create GeneralWaveform object from the output of an
            % oscilloscope and a struct or class containing the channel
            % numbers of each waveform. The DPTSettings object will serve
            % this purpose.
            
            % Create class Object
            newCapture = class;

            % Assign Channel Numbers
            newCapture.channel = copy(channels);
            
            % Assign Waveforms
            newCapture.v_ds = waveforms{newCapture.channel.VDS};
            newCapture.v_gs = waveforms{newCapture.channel.VGS};
            newCapture.i_d = waveforms{newCapture.channel.ID};
            if newCapture.channel.IL > 0
                newCapture.i_l = waveforms{newCapture.channel.IL};
            else
                newCapture.i_l = GeneralWaveform.NOT_RECORDED;
            end
            newCapture.time = waveforms{end};
            
            % Assign channel ordered cell value
            newCapture.channelOrderedCell = waveforms;
            
            GW = newCapture;
        end
    end
    
end

