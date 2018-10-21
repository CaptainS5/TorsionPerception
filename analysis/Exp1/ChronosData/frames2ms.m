function [milliseconds] = frames2ms(frames)

sampleRate = evalin('base','sampleRate');
milliseconds = round(frames * 1000/sampleRate );

end