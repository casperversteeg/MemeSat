function [ ax ] = drawOrbit(ax, Earth, Flight)

if nargin < 2
    error(message('MATLAB:narginchk:notEnoughInputs'));
end


rpd = Flight.mean_motion;
spd = 24 * 3600 / rpd; % Number of seconds for 1 orbit

perigee = (1-Flight.eccentricity) * (3.986004e14 / (2*pi/spd)^2)^(1/3);

t   = linspace(0, spd, 5e3);
or  = t./spd * 2*pi + Flight.arg_perigee; % How far along orbit are we
r   = [cos(or); sin(or); zeros(1,length(or))] .* (perigee* (1 ...
    - (Flight.eccentricity^2))./(1+Flight.eccentricity * cos(or)));
r   = rotMatrix(Flight.rightascension, 3)*rotMatrix(Flight.inclination, 1)*r;

R = 1.5*(Earth.radius);

drawEarth(ax, Earth);
hold(ax, 'on');
view(140, 30); axis(ax, 'equal');
ax.XLim = R*[-1 1]; ax.YLim = R*[-1 1]; ax.ZLim = R*[-1 1];
xlabel(ax,'$x$','interpreter','latex'); 
ylabel(ax,'$y$','interpreter','latex');
zlabel(ax,'$z$','interpreter','latex');
title(ax, "MemeSat Orbit", 'interpreter','latex');
ax.XTick = [];
ax.YTick = [];
ax.ZTick = [];
OR  = plot3(ax, r(1,:), r(2,:), r(3,:));
OR.LineWidth = 2;
Start = plot3(ax, r(1,1), r(2,1), r(3,1));
Start.MarkerSize = 30;
Start.Marker = '.';
an_s = text(r(1,1), r(2,1), r(3,1), 'Periapsis','interpreter','latex',...
    'VerticalAlignment','bottom','HorizontalAlignment','right');
hold(ax, 'off');