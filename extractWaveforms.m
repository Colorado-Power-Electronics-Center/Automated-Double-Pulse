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