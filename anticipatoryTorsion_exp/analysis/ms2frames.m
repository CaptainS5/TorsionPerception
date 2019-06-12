function [frames] = ms2frames(milliseconds)

sampleRate = evalin('base','sampleRate');
frames = round(milliseconds / (1000/sampleRate));

end