function img = generateStimulus(size, freq, phi)

img = zeros(size);
theta = zeros(size);
coordinateCVonvert = linspace(-1,1,size);
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
img(rho<=1) = (sin(theta(rho<=1) * freq + phi)+1)/2;

% imshow (img)

end