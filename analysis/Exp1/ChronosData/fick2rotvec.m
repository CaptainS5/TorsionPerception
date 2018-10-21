function r = fick2rotvec(f)
% construct rotation matrix from fick angles
% BOTH input and output in degrees, for readability
R2D = 180/pi;
fr = f/R2D;
R = Rot(3,fr(3))*Rot(2,fr(2))*Rot(1,fr(1));
% logm sometimes returns very small imaginary parts.
logR = real(logm(R(1:3,1:3)));
r = 0.5*R2D*[logR(3,2)-logR(2,3) ; logR(1,3)-logR(3,1) ; logR(2,1)-logR(1,2)];
end