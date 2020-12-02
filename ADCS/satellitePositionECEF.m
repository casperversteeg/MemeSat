function [ rx, ry, rz ] = satellitePositionECEF(Flight, t, useAnomaly)

if nargin < 3
    useAnomaly = false;
    if nargin < 2
        error(message('MATLAB:narginchk:notEnoughInputs'));
    end
end

if useAnomaly
    TA = t;
else
    TA = t/Flight.sec_per_orbit * 2 * pi;
end

rpd = Flight.mean_motion;
spd = 24 * 3600 / rpd; % Number of seconds for 1 orbit

perigee = (1-Flight.eccentricity) * (3.986004e14 / (2*pi/spd)^2)^(1/3);

TA = TA + Flight.arg_perigee;

r   = [cos(TA); sin(TA); zeros(1,length(TA))] .* (perigee* (1 ...
    - (Flight.eccentricity^2))./(1+Flight.eccentricity * cos(TA)));
r   = rotMatrix(Flight.rightascension, 3)*rotMatrix(Flight.inclination, 1)*r;

if nargout == 1
    rx = r;
else
    rx  = r(1,:);
    ry  = r(2,:);
    rz  = r(3,:);
end

end