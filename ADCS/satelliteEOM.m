function [ Y ] = satelliteEOM(t, x, Sat, Flight)

q = x(1:4); w = x(5:7);
q = q / vecnorm(q);
A = attitudeMatrixFromQuaternion(q);
% w = A' * w;
% Sat = rotateSatellite(Sat, q);
[Rx, Ry, Rz] = satellitePositionECEF(Flight, t);
[th, ph, rh] = cart2sph(Rx, Ry, Rz);
[Bx, By, Bz] = magneticDipole(ph, th, rh);
T = cross(Sat.perm_mag, A*[Bx; By; Bz]);
T = T + hysteresisTorque(A*[Bx; By; Bz], A*Sat.B(:,end), Sat.perm_mag, ...
    Sat.hyst_rod);
I = Sat.mass_moi;

qdot = 0.5 * OMEGA(w) * q;
wdot = I \ crossMatrix(w) * I * w - I \ T;
Y = [qdot; wdot];
Sat.B(:, end+1) = [Bx; By; Bz];

end