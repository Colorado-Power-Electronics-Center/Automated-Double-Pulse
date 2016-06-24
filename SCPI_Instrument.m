classdef SCPI_Instrument < handle
    %SCPI_Instrument Class to handle communication and commands for SCPI
    %Instruments
    %   Designed to be used in conjuction with subclasses that further
    %   expand the abilities for specific types of instruments and specific
    %   instruments. This particular class handles VISA connections,
    %   command sending and response reading. 
    
    properties
        visaAddress
        visaVendor
        visaObj
        connected
        typeStr
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
                pause(.05);
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
        function push2Trigger(self, triggerStr)
            if nargin == 1
                triggerStr = 'trigger';
            end
            disp(['Push any button to ' triggerStr '...']);
            pause;
            self.trigger;
        end
        function clearStatus(self)
            self.sendCommand('*CLS');
        end
        function out = identity(self)
            out = self.query('*IDN?');
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

