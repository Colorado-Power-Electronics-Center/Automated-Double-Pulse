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

classdef SweepPlotSettings
    %
    properties
        title
        numberTitle = 'off';
        xLabel
        xValueName
        xScale = 1;
        yLabel
        yValueName
        yScale = 1;
        zLabel
        zValueName
        zScale = 1;
        
        legendSuffix = 'V';
        legendLocation = 'NorthWest';
        
        markerOrder = {'*','x','s','d','^','v','>','<','p','h'}.';
        
        plotMap@containers.Map;
        
    end
end