classdef WindowSize < matlab.mixin.Copyable
    %WindowSize Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Turn on Window
        turn_on_prequel
        turn_on_time
        
        % Turn off Window
        turn_off_prequel
        turn_off_time

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

