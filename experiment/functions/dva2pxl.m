function [lengthPixelX lengthPixelY] = dva2pxl(lengthX, lengthY)
% translate length in dva to in pixels

global prm
lengthPixelX = lengthX*prm.screen.ppdX;
lengthPixelY = lengthY*prm.screen.ppdX;
% lengthPixelY = lengthY*prm.screen.ppdY;

end

