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

classdef GeneralWaveform < handle
    %GeneralWaveform Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        NOT_RECORDED = -102;
    end    
    
    properties
        approxBusVoltage
        
        % Waveforms
        v_ds
        v_gs
        i_d
        i_l
        v_complementary
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
                % Return if created
                chCell = self.channelOrderedCell;
            % Create if not already done
            elseif ~self.channel.allUnset
                chCell = cell(1, 5);
                chCell(:) = {GeneralWaveform.NOT_RECORDED};
                chCell{self.channel.VDS} = self.v_ds;
                if self.channel.Vcomplementary ~= GeneralWaveform.NOT_RECORDED;
                    chCell{self.channel.Vcomplementary} = self.v_complementary;
                end
                chCell{self.channel.ID} = self.i_d;
                if self.channel.VGS ~= GeneralWaveform.NOT_RECORDED;
                    chCell{self.channel.VGS} = self.v_gs;
                end
                if self.channel.IL ~= GeneralWaveform.NOT_RECORDED;
                    chCell{self.channel.IL} = self.i_l;
                end
                chCell{end} = self.time;
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
            if newCapture.channel.Vcomplementary > 0
                newCapture.v_complementary = waveforms{newCapture.channel.Vcomplementary};
            else
                newCapture.v_complementary = GeneralWaveform.NOT_RECORDED;
            end
            newCapture.time = waveforms{end};
            
            % Assign channel ordered cell value
            newCapture.channelOrderedCell = waveforms;
            
            GW = newCapture;
        end
    end
    
end

