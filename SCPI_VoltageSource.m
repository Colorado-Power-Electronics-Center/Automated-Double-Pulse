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

classdef SCPI_VoltageSource < SCPI_Instrument & handle
    %SCPI_VoltageSource Sub-Class of SCPI_Instrument for use with
    %Voltage Sources.
    %   Currently the class requires the use of a sub class to control
    %   various functions. This class describes functions that can be
    %   implemented, but will throw an error if they are not implemented
    %   within the sub class. 
    
    properties
        outVoltageCmd
        outCurrentCmd
        outputStateCmd
        outputModeCmd
        voltageSlewRisingCmd
        voltageSlewFallingCmd
        initialized = false
    end
    
    properties (Dependent)
        outVoltage
        outCurrent
        outputState
        outputMode
        voltageSlewRising
        voltageSlewFalling
    end
    
    methods (Access = private, Static)
        % Not Implemented Error
        function str = notImplemented(funcName)
            % return string based on funcName
            str = [funcName ' not implemented for this power supply'];
        end
    end
    
    methods
        %% Super Overrides
        function self = SCPI_VoltageSource(visaVendor, visaAddress)
            self@SCPI_Instrument(visaVendor, visaAddress);
        end
        
        %% Control Methods
        % These functions must be implemented in the class for the
        % individual power supply. If called and not implemented an error
        % will be thrown. 
        function initSupply(varargin)
            funcName = strsplit(getfield(dbstack, 'name'), '.');
            error(SCPI_VoltageSource.notImplemented(funcName{2}));
        end
        function setSlewedVoltage(varargin)
            funcName = strsplit(getfield(dbstack, 'name'), '.');
            error(SCPI_VoltageSource.notImplemented(funcName{2}));
        end
        
        %% Stop Methods
        function outputOffZero(self)
            % Function turns output off and sets the output voltage to 0
            self.outputState = 'OFF';
            self.outVoltage = 0;
            self.initialized = false;
        end
        
        
        %% Getters and Setters
        % Template
%         function set.[property](self, [property])
%             [property] = self.U2Str([property]);
%             self.sendCommand(['[command] ' [property]]);
%         end
%         function [property] = get.[property](self)
%             [property] = str2double(self.query('[command]?'));
%         end
        
        function set.outVoltage(self, outVoltage)
            outVoltage = self.U2Str(outVoltage);
            self.sendCommand([self.outVoltageCmd ' ' outVoltage]);
        end
        function outVoltage = get.outVoltage(self)
            outVoltage = str2double(self.query([self.outVoltageCmd '?']));
        end
        function set.outCurrent(self, outCurrent)
            outCurrent = self.U2Str(outCurrent);
            self.sendCommand([self.outCurrentCmd ' ' outCurrent]);
        end
        function outCurrent = get.outCurrent(self)
            outCurrent = str2double(self.query([self.outCurrentCmd '?']));
        end
        function set.outputState(self, outputState)
            outputState = self.U2Str(outputState);
            self.sendCommand([self.outputStateCmd ' ' outputState]);
        end
        function outputState = get.outputState(self)
            outputState = str2double(self.query([self.outputStateCmd '?']));
        end
        
        function set.outputMode(self, outputMode)
            outputMode = self.U2Str(outputMode);
            self.sendCommand([self.outputModeCmd ' ' outputMode]);
        end
        function outputMode = get.outputMode(self)
            outputMode = self.query([self.outputModeCmd '?']);
        end
        function set.voltageSlewFalling(self, voltageSlewFalling)
            voltageSlewFalling = self.U2Str(voltageSlewFalling);
            self.sendCommand([self.voltageSlewFallingCmd ' ' voltageSlewFalling]);
        end
        function voltageSlewFalling = get.voltageSlewFalling(self)
            voltageSlewFalling = self.query([self.voltageSlewFallingCmd '?']);
        end
        function set.voltageSlewRising(self, voltageSlewRising)
            voltageSlewRising = self.U2Str(voltageSlewRising);
            self.sendCommand([self.voltageSlewRisingCmd ' ' voltageSlewRising]);
        end
        function voltageSlewRising = get.voltageSlewRising(self)
            voltageSlewRising = self.query([self.voltageSlewRisingCmd '?']);
        end

    end
end