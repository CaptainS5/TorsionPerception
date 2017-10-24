function lengthPixel = dva2pxl(length)
% translate length in dva to in pixels

global prm
lengthPixel = length*prm.screen.ppd;

end

