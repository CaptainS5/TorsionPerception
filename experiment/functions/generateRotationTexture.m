function imgGrating = generateRotationTexture(outerRadius, innerRadius, freq, phi, contrast, avgLum)
% generate the matrix of the rotating stimuli in square wave

% radius of the grating, in pixels
% freq, cycles/2pi
% phi, phase 
% contrast = (max-min)/(max+min)

% Xiuyun Wu 01/11/2018
global prm
% outerRadius = 200; innerRadius = 20; freq = 2; phi = pi; contrast = 0.25; avgLum = 0.5; prm.screen.backgroundColour = 127; % debugging
img = zeros(2*outerRadius);
theta = zeros(2*outerRadius);
coordinateCVonvert = linspace(-1, 1, 2*outerRadius);
[X, Y] = meshgrid(coordinateCVonvert,-coordinateCVonvert);
rho = sqrt(X.^2+Y.^2);

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
img(rho<=1 & rho>=1/outerRadius*innerRadius) = square(theta(rho<=1 & rho>=1/outerRadius*innerRadius) * freq + phi)*(maxColor-avgLum)+avgLum;

img = img*255;
imgReal = img(rho<=1 & rho>=1/outerRadius*innerRadius); % effective area of the image
img(rho>1 | rho<1/outerRadius*innerRadius) = prm.screen.backgroundColour; % the same as the background colour
% figure
% imshow(img/255)

% adding transparency
trans = zeros(2*outerRadius);
trans(rho<=1 & rho>=1/outerRadius*innerRadius) = 255;

% imgGrating = img;
imgGrating(:, :, 1) = img;
imgGrating(:, :, 2) = trans;

prm.grating.lightest = max(imgReal(:));
prm.grating.darkest = min(imgReal(:));

% end