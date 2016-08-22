classdef channelMapper < matlab.mixin.Copyable
    %channelMapper Summary of this class goes here
    %   Detailed explanation goes here

    properties
        VDS = GeneralWaveform.NOT_RECORDED;
        VGS = GeneralWaveform.NOT_RECORDED;
        ID = GeneralWaveform.NOT_RECORDED;
        IL = GeneralWaveform.NOT_RECORDED;
    end

    methods
        function self = channelMapper(VDS_Channel, VGS_Channel,...
                                      ID_Channel, IL_Channel)
            if nargin > 0
                self.VDS = VDS_Channel;
                self.VGS = VGS_Channel;
                self.ID = ID_Channel;
                self.IL = IL_Channel;
            end
        end
        function out = allUnset(self)
            Channels = [self.VDS, self.VGS, self.ID, self.IL];
            out =  all(Channels == GeneralWaveform.NOT_RECORDED);
        end
    end
    
end
