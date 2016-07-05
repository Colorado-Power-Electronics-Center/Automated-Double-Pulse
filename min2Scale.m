function [scale, position] = min2Scale(minValue, maxValue, numDivisions, percentBuffer)
    data_range = maxValue - minValue;
    scale = (data_range / numDivisions);
    scale = scale * (1 + percentBuffer / 100);
    position = -mean([minValue, maxValue]) / scale;
end