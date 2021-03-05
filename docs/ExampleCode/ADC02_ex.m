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

Rx   = @(t) [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)];
Ry   = @(t) [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)];
Rz   = @(t) [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];

t1   = 0:1e-1:pi/3;
t2   = 0:1e-1:pi/3;
t3   = 0:1e-1:pi/4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

V = quiver3(0, 0, 0, 0, 0, 0, 0);
for i = 1:length(t1)
    vx = Rx(t1(i))*iht; vy = Rx(t1(i))*jht; vz = Rx(t1(i))*kht; 
    [Iht.UData, Iht.VData, Iht.WData] = deal(vx(1), vx(2), vx(3));
    [Jht.UData, Jht.VData, Jht.WData] = deal(vy(1), vy(2), vy(3));
    [Kht.UData, Kht.VData, Kht.WData] = deal(vz(1), vz(2), vz(3));
    an_x.Position = vx;
    an_y.Position = vy;
    an_z.Position = vz;
    drawnow;
end

for i = 1:length(t2)
    wx = Rz(t2(i))*vx; wy = Rz(t2(i))*vy; wz = Rz(t2(i))*vz; 
    Iht.UData = wx(1);
    Iht.VData = wx(2);
    Iht.WData = wx(3);
    Jht.UData = wy(1);
    Jht.VData = wy(2);
    Jht.WData = wy(3);
    Kht.UData = wz(1);
    Kht.VData = wz(2);
    Kht.WData = wz(3);
    drawnow;
end

for i = 1:length(t3)
    ux = Ry(t3(i))*wx; uy = Ry(t3(i))*wy; uz = Ry(t3(i))*wz; 
    Iht.UData = ux(1);
    Iht.VData = ux(2);
    Iht.WData = ux(3);
    Jht.UData = uy(1);
    Jht.VData = uy(2);
    Jht.WData = uy(3);
    Kht.UData = uz(1);
    Kht.VData = uz(2);
    Kht.WData = uz(3);
    drawnow;
end