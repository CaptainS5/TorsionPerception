function torsion = ListingTorsion( c, n )
%ListingTorsion Compute Torsion for 2D eye position in Fick-Chronos coords
% INPUT
%   c : (x, y, z) coords of eye position, using Chronos's fick angles
%   n: 1x4 vector, for Listing's plane, in rotation vector coords
% OUTPUT
%   torsion: in Chronos's fick angles

    function d = distance(t)
        fick = [t; c(2); c(1)]; % now in fick angles
        d = n * [fick2rotvec(fick); 1];
    end
options = optimoptions('fsolve','Display','off'); % no verbose output
torsion = fsolve(@distance,c(3),options);

end