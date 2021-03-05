%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ADC 03
%   Written by: Casper Versteeg
%   Duke University
%   2021/03/02
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

A  = 1;

phi = @(r, th, n) A*r.^n.*cos(n*th);

v1 = @(r, th, n) A*n*r.^(n-1) .* cos(n*th);
v2 = @(r, th, n) -A*n*r.^(n-1) .* sin(n*th);

% [R, TH] = polarSquare(0:5, linspace(0, 3*pi/2, 20));
[R, TH] = meshgrid(0:5, linspace(0, 3*pi/2, 20));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F = figure;
set(F, 'Units', 'Pixels', 'OuterPosition', [1160 600 900 450]);
t = tiledlayout(F, 1, 2, 'TileSpacing', 'Compact','Padding','Compact');
ax1 = nexttile(t); grid(ax1, 'on'); hold(ax1, 'on'); axis(ax1, 'equal');
ax2 = nexttile(t); grid(ax2, 'on'); hold(ax2, 'on'); axis(ax2, 'equal');

[Vx, Vy] = polarGrad2cartGrad(v1(R, TH, 2/3), v2(R,TH,2/3), TH);
[X,Y] = pol2cart(TH, R);

C1 = contour(ax1, X, Y, phi(R,TH, 2/3));
Q1 = quiver(ax1, X, Y, Vx, Vy, 0);
xlabel(ax1, '$x$','interpreter','latex');
ylabel(ax1, '$y$','interpreter','latex');
ax1.TickLabelInterpreter = 'latex';
title(ax1, '$n = 2/3$','interpreter','latex');
ax1.XLim = [-5 5]; ax1.YLim = [-5 5];

[X, Y] = meshgrid(0:0.5:5, 0:0.5:5);
[R, TH] = betterCart2Pol(X,Y);
[Vx, Vy] = polarGrad2cartGrad(v1(R, TH, 2), v2(R,TH,2), TH);
C2 = contour(ax2, X, Y, phi(R,TH, 2));
Q2 = quiver(ax2, X, Y, Vx, Vy);
xlabel(ax2, '$x$','interpreter','latex');
ylabel(ax2, '$y$','interpreter','latex');
ax2.TickLabelInterpreter = 'latex';
title(ax2, '$n = 2$','interpreter','latex');
ax2.XLim = [0 5]; ax2.YLim = [0 5];

function [R, TH] = betterCart2Pol(X, Y)

[TH, R] = cart2pol(X, Y);
TH = TH + (Y < 0)*2*pi;

end

function [R, TH] = polarSquare(r, th)

[R, TH] = meshgrid(r, th);
R = R .* min([1./abs(cos(th)); 1./abs(sin(th))])';

end

function [Vx, Vy] = polarGrad2cartGrad(Vr, Vth, TH)

Vx = Vr .* cos(TH) - Vth .* sin(TH);
Vy = Vr .* sin(TH) + Vth .* cos(TH);

end