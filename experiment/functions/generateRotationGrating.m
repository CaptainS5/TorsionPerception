function imgGrating = generateRotationGrating(outerRadius, innerRadius, freq, phi, contrast, avgLum)
% generate the matrix of the rotating grating; outside the circle is
% transparent

% radius of the grating, in pixels
% freq, cycles/2pi
% phi, phase 

% 09/24/2017, Yuchi Zhang, edited by Xiuyun Wu 09/26/2017
% outerRadius = 200; innerRadius = 20; freq = 8; phi = 0; contrast = 0.985; avgLum = 0.5; % debugging
global prm
img = zeros(2*outerRadius);
theta = zeros(2*outerRadius);
coordinateCVonvert = linspace(-contrast, contrast, 2*outerRadius);
[X, Y] = meshgrid(coordinateCVonvert,-coordinateCVonvert);
rho = sqrt(X.^2+Y.^2);

% theta =
theta(X>0) = atan(Y(X>0)./X(X>0));
theta((X<0 & Y>=0)) = atan(Y(X<0 & Y>=0)./X(X<0 & Y>=0))+pi;
theta((X<0 & Y<0)) = atan(Y(X<0 & Y<0)./X(X<0 & Y<0))-pi;
theta((X==0 & Y>0)) = pi/2;
theta((X==0 & Y<0)) = -pi/2;
theta((X==0 & Y==0)) = 0;

% i = sin(theta * freq + phi)
% ratio = (1+contrast)/(1-contrast);
% img(rho<=ratio & rho>=ratio/outerRadius*innerRadius) = sin(theta(rho<=ratio & rho>=ratio/outerRadius*innerRadius) * freq + phi)/2*ratio + avgLum;
img(rho<=contrast & rho>=contrast/outerRadius*innerRadius) = sin(theta(rho<=contrast & rho>=contrast/outerRadius*innerRadius) * freq + phi)/2*contrast + avgLum;
imgReal = img(rho<=contrast & rho>=contrast/outerRadius*innerRadius); % effective area of the image
% figure
% imshow(img)

% adding transparency
trans = zeros(2*outerRadius);
trans(rho<=contrast & rho>=contrast/outerRadius*innerRadius) = 1;

% imgGrating = img;
imgGrating(:, :, 1) = img*255;
imgGrating(:, :, 2) = trans;

prm.grating.lightest = max(imgReal(:)*255);
prm.grating.darkest = min(imgReal(:)*255);

end