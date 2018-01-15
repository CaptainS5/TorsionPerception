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
imgFlash = ones(2*gratingOuterRadius, 2*gratingOuterRadius, 3); % RGB planes
coordinateCVonvert = linspace(-gratingOuterRadius, gratingOuterRadius, 2*gratingOuterRadius);
[X, Y] = meshgrid(coordinateCVonvert,-coordinateCVonvert);

% coordinates of the dots, marking by 1
coor = zeros(2*gratingOuterRadius);
if axis==0 % horizontal at first
    coor(sqrt((X-gratingOuterRadius+flashRadius).^2+Y.^2) <= flashRadius) = 1;
    coor(sqrt((X+gratingOuterRadius-flashRadius).^2+Y.^2) <= flashRadius) = 1;
elseif axis==1 % vertical at first
    coor(sqrt(X.^2+(Y-gratingOuterRadius+flashRadius).^2) <= flashRadius) = 1;
    coor(sqrt(X.^2+(Y+gratingOuterRadius-flashRadius).^2) <= flashRadius) = 1;
end

% add color 
% 4-should be transparency,  but for some reason does not work at
% all!!
for ii = 1:3
    img = imgFlash(:, :, ii);
    img = img.*coor*color(ii);
    img(coor==0) = imgGrating(coor==0);
    imgFlash(:, :, ii) = img;
end

% figure
% imshow(imgFlash(:, :, 1:3)/255)
% end