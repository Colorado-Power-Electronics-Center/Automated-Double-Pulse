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

classdef SCPI_Instrument < handle
    %SCPI_Instrument Class to handle communication and commands for SCPI
    %Instruments
    %   Designed to be used in conjunction with subclasses that further
    %   expand the abilities for specific types of instruments and specific
    %   instruments. This particular class handles VISA connections,
    %   command sending and response reading. 
    
    properties
        visaAddress
        visaVendor
        visaObj
        connected
        typeStr
        commandDelay = 0.05;
    end
    
    methods
        function self = SCPI_Instrument(visaVendor, visaAddress)
            if nargin > 0
                self.typeStr = 'Instrument';
                self.visaAddress = visaAddress;
                self.visaVendor = visaVendor;
                self.connected = false;
                self.createVisaObj
            end
        end
        function set.visaVendor(self, Vendor)
            if (strcmpi(Vendor, 'tek') ||...
                    strcmpi(Vendor, 'agilent') ||...
                    strcmpi(Vendor, 'ni'))
                self.visaVendor = Vendor;
            else
                error('Invalid VISA Vendor')
            end
        end
        function createVisaObj(self)
            self.visaObj = visa(self.visaVendor, self.visaAddress);
        end
        function clearVisaObj(self)
            delete(self.visaObj);
        end
        function connect(self)
            fopen(self.visaObj);
            self.connected = true;
        end
        function disconnect(self)
            fclose(self.visaObj);
            self.connected = false;
        end
        function sendCommand(self, command)
            if self.connected
                fprintf(self.visaObj, command);
                pause(self.commandDelay);
            else
                error([self.typeStr ' is not connected'])
            end
        end
        function out = readResponse(self)
            if self.connected
                out = fscanf(self.visaObj);
            else
                error([self.typeStr ' is not connected'])
            end
        end
        function out = query(self, query)
            self.sendCommand(query);
            out = self.readResponse();
        end
        function out = numQuery(self, queryStr)
            r = self.query(queryStr);
            out = str2double(r);
        end
        function out = binBlockQuery(self, query, precision)
            self.sendCommand(query);
            out = binblockread(self.visaObj, precision);
        end
        
        function reset(self)
            self.sendCommand('*RST');
        end
        function trigger(self)
            self.sendCommand('*TRG');
        end
        function push2Trigger(self, triggerStr, push2pulse)
            if nargin == 1
                triggerStr = 'trigger';
                push2pulse = true;
            elseif nargin == 2
                % Check if user included only push2pulse in args
                if islogical(triggerStr)
                    push2pulse = triggerStr;
                    triggerStr = 'trigger';
                else
                    push2pulse = true;
                end
            end
            if push2pulse
                disp(['Push any button to ' triggerStr '...']);
                pause;
            end
            self.trigger;
        end
        function clearStatus(self)
            self.sendCommand('*CLS');
        end
        function out = identity(self)
            out = self.query('*IDN?');
        end
        function out = operationComplete(self)
            out = self.query('*OPC?');
        end
    end
    methods (Static)
        function out = U2Str(UStr)
            % U2Str Takes unknown data type and converts 
            % to string if numeric
            if isnumeric(UStr)
                out = num2str(UStr);
            else
                out = UStr;
            end
        end
    end
    
end

