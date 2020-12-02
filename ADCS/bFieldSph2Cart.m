function [ bx, by, bz ] = bFieldSph2Cart(r, RE, theta, phi, fns)

if nargin < 5
    B0  = 3.12e-5;              % Mean |B| at Earth surface,    [Tesla]
    fns = {@(r, theta, phi) -2*B0*(RE/r).^3.*sin(phi),...
           @(r, theta, phi) 0,...
           @(r, theta, phi) B0*(RE/r).^3.*cos(phi)};
end

br = fns{1}(r, theta, phi);
bt = fns{2}(r, theta, phi);
bp = fns{3}(r, theta, phi);

bx = cos(phi)*cos(theta)*br - sin(theta)*bt - sin(phi)*cos(theta)*bp;
by = cos(phi)*sin(theta)*br + cos(theta)*bt - sin(phi)*sin(theta)*bp;
bz = sin(phi)*br + cos(phi)*bp;

end