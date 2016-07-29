classdef SCPI_VoltageSource < SCPI_Instrument & handle
    %SCPI_VoltageSource Sub-Class of SCPI_Instrument for use with
    %Voltage Sources.
    %   Currently the class requires the use of a sub class to control
    %   various functions. This class describes functions that can be
    %   implemented, but will throw an error if they are not implemented
    %   within the sub class. 
    
    properties
        outVoltageCmd
        outputStateCmd
        initialized = false
    end
    
    properties (Dependent)
        outVoltage
        outputState
    end
    
    methods (Access = private, Static)
        % Not Implemented Error
        function str = notImplemented(funcName)
            % return string based on funcName
            str = [funcName ' not implemented for this power supply'];
        end
    end
    
    methods
        %% Super Overides
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
        function set.outputState(self, outputState)
            outputState = self.U2Str(outputState);
            self.sendCommand([self.outputStateCmd ' ' outputState]);
        end
        function outputState = get.outputState(self)
            outputState = str2double(self.query([self.outputStateCmd '?']));
        end
    end
end