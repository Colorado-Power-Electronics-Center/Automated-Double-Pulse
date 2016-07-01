function [scale, position] = min2Scale(minValue, maxValue, numDivisions, percentBuffer)
    data_range = maxValue - minValue;
    scale = (data_range / numDivisions);
    position = (minValue/scale) + (numDivisions / 2);
    scale = scale * (1 + percentBuffer / 100);
    position = position * (1 - percentBuffer / 100);
end