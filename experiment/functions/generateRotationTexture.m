function imgGrating = generateRotationTexture(outerRadius, innerRadius, freq, phi, contrast, avgLum)
% generate the matrix of the rotating stimuli in square wave

% radius of the grating, in pixels
% freq, cycles/2pi
% phi, phase 
% contrast = (max-min)/(max+min)

% Xiuyun Wu 01/11/2018
global prm
% outerRadius = 10; innerRadius = 0; freq = 8; phi = pi; contrast = 0.25; avgLum = 0.5; prm.screen.backgroundColour = 127; % debugging
[outerRadiusX outerRadiusY] = dva2pxl(outerRadius, outerRadius);
outerRadiusX = round(outerRadiusX);
outerRadiusY = round(outerRadiusY);
[innerRadiusX innerRadiusY] = dva2pxl(innerRadius, innerRadius);
innerRadiusX = round(innerRadiusX);
innerRadiusY = round(innerRadiusY);
img = zeros(2*outerRadiusY, 2*outerRadiusX);
theta = zeros(2*outerRadiusY, 2*outerRadiusX);
coordinateCVonvertX = linspace(-1, 1, 2*outerRadiusX);
coordinateCVonvertY = linspace(-1, 1, 2*outerRadiusY);
[X, Y] = meshgrid(coordinateCVonvertX,-coordinateCVonvertY);
rho = sqrt(X.^2+Y.^2);
rhoInner = sqrt((X*outerRadiusX/innerRadiusX).^2+(Y*outerRadiusY/innerRadiusY).^2);

% theta =
theta(X>0) = atan(Y(X>0)./X(X>0));
theta((X<0 & Y>=0)) = atan(Y(X<0 & Y>=0)./X(X<0 & Y>=0))+pi;
theta((X<0 & Y<0)) = atan(Y(X<0 & Y<0)./X(X<0 & Y<0))-pi;
theta((X==0 & Y>0)) = pi/2;
theta((X==0 & Y<0)) = -pi/2;
theta((X==0 & Y==0)) = 0;

ratio = (1+contrast)/(1-contrast); % max/min ratio of color in [0, 1]
maxColor = 2*avgLum/(1+1/ratio); % the number for the brightest color in range [0, 1]
% % sine wave 
% % i = sin(theta * freq + phi)
% img(rho<=1 & rho>=1/outerRadius*innerRadius) = sin(theta(rho<=1 & rho>=1/outerRadius*innerRadius) * freq + phi)*(maxColor-avgLum)+avgLum;

% square wave 
img(rho<=1 & rhoInner>=1) = square(theta(rho<=1 & rhoInner>=1) * freq + phi)*(maxColor-avgLum)+avgLum;

img = img*255;
imgReal = img(rho<=1 & rhoInner>=1); % effective area of the image
img(rho>1 | rhoInner<1) = prm.screen.backgroundColour; % the same as the background colour
% figure
% imshow(img/255)

% adding transparency
trans = zeros(2*outerRadiusY, 2*outerRadiusX);
trans(rho<=1 & rhoInner>=1) = 255;

% imgGrating = img;
imgGrating(:, :, 1) = img;
imgGrating(:, :, 2) = trans;

prm.grating.lightest = max(imgReal(:, :, 1));
prm.grating.darkest = min(imgReal(:, :, 1));

% end