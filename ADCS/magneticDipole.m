function [ bx, by, bz ] = magneticDipole(phi, theta, r, RE)

if nargin < 4
    RE = 6378e3;
    if nargin < 3
        error(message('MATLAB:narginchk:notEnoughInputs'));
    end
end

B0  = 3.12e-5;              % Mean |B| at Earth surface,    [Tesla]

br      = -2*B0*(RE./r).^3.*sin(phi); 
bt      = 0;
bp      = B0*(RE./r).^3.*cos(phi);

bx = cos(phi).*cos(theta).*br - sin(theta).*bt - sin(phi).*cos(theta).*bp;
by = cos(phi).*sin(theta).*br + cos(theta).*bt - sin(phi).*sin(theta).*bp;
bz = sin(phi).*br + cos(phi).*bp;

% bx = 0*phi; by = 0*phi; bz = B0*ones(1,length(phi));

end