%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ADC 01
%   Written by: Casper Versteeg
%   Duke University
%   2021/01/22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

a   = 0.25;

iht = [1; 0];
jht = [0; 1];

x   = @(t) 2*a*(1 - cos(t)) .* cos(t);
y   = @(t) 2*a*(1 - cos(t)) .* sin(t);

t   = 0:1e-2:2*pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xt  = x(t);
yt  = y(t);

F = figure;
ax = axes(F); grid(ax, 'on'); hold(ax, 'on'); axis(ax, 'equal');

Iht = quiver(ax, 0, 0, iht(1), iht(2), 0);
Jht = quiver(ax, 0, 0, jht(1), jht(2), 0);

Iht.LineWidth = 1.5; Iht.MaxHeadSize = 0.3; Iht.Color = 'red';
Jht.LineWidth = 1.5; Jht.MaxHeadSize = 0.3; Jht.Color = 'blue';

an_x = text(1, 0, 0, '$x$','interpreter','latex',...
    'VerticalAlignment','bottom','HorizontalAlignment','right');
an_y = text(0, 1, 0, '$y$','interpreter','latex', ...
    'VerticalAlignment', 'bottom');
ax.XLim = [-1.1 1.1]; ax.YLim = [-1.1 1.1];
ax.ColorOrderIndex = 1;
ax.TickLabelInterpreter = 'latex';

P = plot(0, 0);
V = quiver(0, 0, 0, 0, 0);
for i = 1:length(t)
    P.XData = xt(1:i);
    P.YData = yt(1:i);
    V.UData = x(t(i));
    V.VData = y(t(i));
    drawnow;
end