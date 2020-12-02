function [ e ] = computeAngleError(soln, Sat, Flight)

% Hurray for lazy temp variable naming
[tmpx, tmpy, tmpz] = satellitePositionECEF(Flight, soln.x);
[tpth, tpph, tprh] = cart2sph(tmpx, tmpy, tmpz);
[tmpx, tmpy, tmpz] = magneticDipole(tpph, tpth, tprh);
tmpb = [tmpx; tmpy; tmpz];
tmpt = 0*tmpb;
for i = 1:length(soln.x)
    A = attitudeMatrixFromQuaternion(soln.y(1:4, i) / vecnorm(soln.y(1:4,i)));
    tmpt(:,i) = A * Sat.perm_mag;
end

e = acos(dot(tmpt, tmpb, 1) ./ (vecnorm(tmpt, 2, 1).*vecnorm(tmpb, 2, 1)));


end