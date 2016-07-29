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

