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

classdef WindowSize < matlab.mixin.Copyable
    %WindowSize Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Turn on Window
        turn_on_prequel = 30e-9;
        turn_on_time = 80e-9;
        
        % Turn off Window
        turn_off_prequel = 30e-9;
        turn_off_time = 80e-9;

        % Window Sample Rate
        sampleRate
    end
    
    properties (Dependent)
        % Turn on Window
        turn_on_prequel_idxs
        turn_on_time_idxs
        
        % Turn off Window
        turn_off_prequel_idxs
        turn_off_time_idxs
    end
    
    methods
        % Turn on Window
        function idxs = get.turn_on_prequel_idxs(self)
            idxs = self.sampleRate * self.turn_on_prequel;
        end            
        function idxs = get.turn_on_time_idxs(self)
            idxs = self.sampleRate * self.turn_on_time;
        end            
        
        % Turn off Window
        function idxs = get.turn_off_prequel_idxs(self)
            idxs = self.sampleRate * self.turn_off_prequel;
        end            
        function idxs = get.turn_off_time_idxs(self)
            idxs = self.sampleRate * self.turn_off_time;
        end                
    end
    
end

