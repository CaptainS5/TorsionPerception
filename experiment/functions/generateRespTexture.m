function img = generateRespTexture(gratingOuterRadius, gratingInnerRadius, flashRadius, color)
% generate the matrix of the flash dots on the rotating stimuli

% radius of the grating and the flash, in pixels
% color, rgb matrix, range [0, 255]
% location, 0-horizontal, 1-vertical

% Xiuyun Wu 01/13/2018
global prm
% debugging
% gratingOuterRadius = 200; gratingInnerRadius = 20;  flashRadius = 50; color = [255 0 0]; prm.screen.backgroundColour = 127; 

img = ones(2*gratingOuterRadius, 2*gratingOuterRadius, 3); % RGB planes
coordinateCVonvert = linspace(-gratingOuterRadius, gratingOuterRadius, 2*gratingOuterRadius);
[X, Y] = meshgrid(coordinateCVonvert,-coordinateCVonvert);

% coordinates of the dots, marking by 1
coor = zeros(2*gratingOuterRadius);
coor(sqrt(X.^2+(Y-gratingOuterRadius+flashRadius).^2) <= flashRadius) = 1;
coor(sqrt(X.^2+(Y+gratingOuterRadius-flashRadius).^2) <= flashRadius) = 1;

% add color 
for ii = 1:3
    imgTemp = img(:, :, ii);
    imgTemp = imgTemp.*coor*color(ii);
    imgTemp(coor==0) = prm.screen.backgroundColour;
    img(:, :, ii) = imgTemp;
end

% figure
% imshow(img(:, :, 1:3)/255)
% end