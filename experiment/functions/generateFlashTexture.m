function imgFlash = generateFlashTexture(gratingOuterRadius, gratingInnerRadius, flashRadius, color, axis, imgGrating)
% generate the matrix of the flash dots on the rotating stimuli

% radius of the grating and the flash, in pixels
% color, rgb matrix, range [0, 255]
% location, 0-horizontal, 1-vertical

% Xiuyun Wu 01/13/2018
global prm
% debugging
% gratingOuterRadius = 200; gratingInnerRadius = 20;  flashRadius = 50; color = [255 0 0 0]; axis = 1; 
% freq = 2; phi = pi; contrast = 0.25; avgLum = 0.5; prm.screen.backgroundColour = 127;
[gratingOuterRadiusX gratingOuterRadiusY] = dva2pxl(gratingOuterRadius, gratingOuterRadius);
gratingOuterRadiusX = round(gratingOuterRadiusX);
gratingOuterRadiusY = round(gratingOuterRadiusY);
[gratingInnerRadiusX gratingInnerRadiusY] = dva2pxl(gratingInnerRadius, gratingInnerRadius);
gratingInnerRadiusX = round(gratingInnerRadiusX);
gratingInnerRadiusY = round(gratingInnerRadiusY);
[flashRadiusX flashRadiusY] = dva2pxl(flashRadius, flashRadius);
flashRadiusX = round(flashRadiusX);
flashRadiusY = round(flashRadiusY);
imgFlash = ones(2*gratingOuterRadiusY, 2*gratingOuterRadiusX, 4); % RGBA planes
coordinateCVonvertX = linspace(-1, 1, 2*gratingOuterRadiusX);
coordinateCVonvertY = linspace(-1, 1, 2*gratingOuterRadiusY);
[X, Y] = meshgrid(coordinateCVonvertX, -coordinateCVonvertY);
rho = sqrt(X.^2+Y.^2);
rhoInner = sqrt((X*gratingOuterRadiusX/gratingInnerRadiusX).^2+(Y*gratingOuterRadiusY/gratingInnerRadiusY).^2);

% coordinates of the dots, marked by 1
coor = zeros(2*gratingOuterRadiusY, 2*gratingOuterRadiusX);
if axis==0 % horizontal at first
    coor(sqrt(((X-1+flashRadiusX/gratingOuterRadiusX)/flashRadiusX*gratingOuterRadiusX).^2+(Y/flashRadiusY*gratingOuterRadiusY).^2) <= 1) = 1;
    coor(sqrt(((X+1-flashRadiusX/gratingOuterRadiusX)/flashRadiusX*gratingOuterRadiusX).^2+(Y/flashRadiusY*gratingOuterRadiusY).^2) <= 1) = 1;
elseif axis==1 % vertical at first
    coor(sqrt((X/flashRadiusX*gratingOuterRadiusX).^2+((Y-1+flashRadiusY/gratingOuterRadiusY)/flashRadiusY*gratingOuterRadiusY).^2) <= 1) = 1;
    coor(sqrt((X/flashRadiusX*gratingOuterRadiusX).^2+((Y+1-flashRadiusY/gratingOuterRadiusY)/flashRadiusY*gratingOuterRadiusY).^2) <= 1) = 1;
end
coor(rho<=1 & rhoInner>=1 & coor~=1) = 2;

% add color 
% 4-transparency
for ii = 1:4
    if ii<=3
        img = imgFlash(:, :, ii);
        img = img.*coor*color(ii);
        img(coor~=1) = imgGrating(coor~=1);
    else
        img = 255*imgFlash(:, :, ii);
        img(coor==0) = 0;
    end
    imgFlash(:, :, ii) = img;
end

% figure
% imshow(imgFlash(:, :, 1:3)/255)
% end