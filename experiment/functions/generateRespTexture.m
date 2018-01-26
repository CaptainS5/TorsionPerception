function img = generateRespTexture(gratingOuterRadius, gratingInnerRadius, flashRadius, color, axis)
% generate the matrix of the flash dots on the rotating stimuli

% radius of the grating and the flash, in pixels
% color, rgb matrix, range [0, 255]
% location, 0-horizontal, 1-vertical

% Xiuyun Wu 01/13/2018
global prm
% debugging
% gratingOuterRadius = 400; gratingInnerRadius = 0;  flashRadius = 50; color = [0 0 0]; axis = 1; prm.screen.backgroundColour = 127; 
% prm.grating.respColour = [100 100 100];
img = ones(2*gratingOuterRadius, 2*gratingOuterRadius, 3); % RGB planes
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
coor(sqrt(X.^2+Y.^2)<=gratingOuterRadius & sqrt(X.^2+Y.^2)>=gratingInnerRadius & coor~=1) = 2;

% add color 
for ii = 1:3
    imgTemp = img(:, :, ii);
    imgTemp = imgTemp.*coor*color(ii);
    imgTemp(coor==2) = prm.grating.respColour(ii);
    imgTemp(coor==0) = prm.screen.backgroundColour;
    img(:, :, ii) = imgTemp;
end

% figure
% imshow(img(:, :, 1:3)/255)
% end