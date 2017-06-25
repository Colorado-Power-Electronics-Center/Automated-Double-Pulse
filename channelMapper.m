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

classdef channelMapper < matlab.mixin.Copyable
    %channelMapper Summary of this class goes here
    %   Detailed explanation goes here

    properties
        VDS = GeneralWaveform.NOT_RECORDED;
        VGS = GeneralWaveform.NOT_RECORDED;
        ID = GeneralWaveform.NOT_RECORDED;
        IL = GeneralWaveform.NOT_RECORDED;
        Vcomplementary = GeneralWaveform.NOT_RECORDED;
    end

    methods
        function self = channelMapper(VDS_Channel, VGS_Channel,...
                                      ID_Channel, IL_Channel, Vcomplementary_Channel)
            if nargin > 0
                self.VDS = VDS_Channel;
                self.VGS = VGS_Channel;
                self.ID = ID_Channel;
                self.IL = IL_Channel;
                self.Vcomplementary = Vcomplementary_Channel;
            end
        end
        function out = allUnset(self)
            Channels = [self.VDS, self.VGS, self.ID, self.IL, self.Vcomplementary];
            out =  all(Channels == GeneralWaveform.NOT_RECORDED);
        end
    end
    
end
