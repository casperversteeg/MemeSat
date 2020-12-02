function [ Sat ] = rotateSatellite(Sat, q)

A = attitudeMatrixFromQuaternion(q);
% Sat.model.Vertices = (A * Sat.model.Vertices')';
% Sat.mass_moi = A * Sat.mass_moi;
% Sat.perm_mag = A * Sat.perm_mag;
Sat.attitude_quaternion = q;

end