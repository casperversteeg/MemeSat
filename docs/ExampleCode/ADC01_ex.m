%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ADC 01 Exercise
%   Written by: Casper Versteeg
%   Duke University
%   2021/01/22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

R   = 0.7;
r   = 0.2;

iht = [1; 0; 0];
jht = [0; 1; 0];
kht = [0; 0; 1];

x   = @(t) (R + r*cos(30*t)) .* cos(t);
y   = @(t) (R + r*cos(30*t)) .* sin(t);
z   = @(t) r*sin(30*t);

t   = 0:1e-2:2*pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xt  = x(t);
yt  = y(t);
zt  = z(t);

F = figure;
ax = axes(F); grid(ax, 'on'); hold(ax, 'on'); axis(ax, 'equal');

Iht = quiver3(ax, 0, 0, 0, iht(1), iht(2), iht(3), 0);
Jht = quiver3(ax, 0, 0, 0, jht(1), jht(2), jht(3), 0);
Kht = quiver3(ax, 0, 0, 0, kht(1), kht(2), kht(3), 0);

Iht.LineWidth = 1.5; Iht.MaxHeadSize = 0.3; Iht.Color = 'red'; 
Jht.LineWidth = 1.5; Jht.MaxHeadSize = 0.3; Jht.Color = 'blue'; 
Kht.LineWidth = 1.5; Kht.MaxHeadSize = 0.3; Kht.Color = 'green'; 

an_x = text(1, 0, 0, '$x$','interpreter','latex',...
    'VerticalAlignment','bottom','HorizontalAlignment','right');
an_y = text(0, 1, 0, '$y$','interpreter','latex');
an_z = text(0, 0, 1, '$z$','interpreter','latex');
ax.XLim = [-1.1 1.1]; ax.YLim = [-1.1 1.1]; ax.ZLim = [-1.1 1.1];
ax.ColorOrderIndex = 1;
ax.TickLabelInterpreter = 'latex';
view(130, 30);

P = plot3([0 0], [0 0], [0 0]);
V = quiver3(0, 0, 0, 0, 0, 0, 0);
for i = 1:length(t)
    P.XData = xt(1:i);
    P.YData = yt(1:i);
    P.ZData = zt(1:i);
    V.UData = x(t(i));
    V.VData = y(t(i));
    V.WData = z(t(i));
    drawnow;
end