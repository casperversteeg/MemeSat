function [ ax ] = drawEarthMagneticField(ax, R, Earth, nt, np)

if nargin < 5
    np = 20;
    if nargin < 4
        nt = 20;
        if nargin < 3
            error(message('MATLAB:narginchk:notEnoughInputs'));
        end
    end
end

th = linspace(0, 2*pi, nt);
ph = linspace(-pi/2, pi/2, np);

X = zeros(1, nt*np); Y = X; Z = X;
Bx = X; By = X; Bz = X;


for i = 1:length(th)
    for j = 1:length(ph)
        In  = (i-1)*nt + j;
        [X(In), Y(In), Z(In)] = positionSph2Cart(R, th(i), ph(j));
        [Bx(In), By(In), Bz(In)] = magneticDipole(ph(j), th(i), R);
    end
end

S = drawEarth(ax, Earth);
hold(ax,'on');
EM_p = quiver3(ax, X, Y, Z, Bx, By, Bz); 
EM_p.MaxHeadSize = 0.5;
view(140, 30); axis(ax, 'equal');
xlabel(ax,'$x$','interpreter','latex'); 
ylabel(ax,'$y$','interpreter','latex');
zlabel(ax,'$z$','interpreter','latex');
title(ax,'Dipole magnetic field model','interpreter','latex');
ax.XTick = [];
ax.YTick = [];
ax.ZTick = [];

end