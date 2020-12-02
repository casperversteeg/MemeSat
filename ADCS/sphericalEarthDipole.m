function [ Earth ] = sphericalEarthDipole(R)

B0      = 3.12e-5;              % Mean |B| at Earth surface,    [Tesla]
% Spherical earth model:
E = sphericalEarth(R);

% Dipole magnetic field model (in spherical coordinates, [Tesla]):
Br      = @(r, theta, phi) -2*B0*(R/r).^3.*sin(phi); 
Btheta  = @(r, theta, phi) 0;
Bphi    = @(r, theta, phi) B0*(R/r).^3.*cos(phi);
Earth   = struct('model', E, 'radius', R, 'mag_R', Br,...
    'mag_theta', Btheta, 'mag_phi', Bphi);

end