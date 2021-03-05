%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Energy/Momentum Integrals
%   Written by: Casper Versteeg
%   Duke University
%   2021/01/01
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; addpath("../draw");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

R = [1 0.5 0.3]*1.7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F1 = figure;
set(F1, 'Units', 'pixels', 'OuterPosition', [100,1600,800,800],...
    'Color', 'white');
ax1 = axes(F1); hold(ax1, 'on'); grid(ax1, 'off');
MS = patch(ax1, getMomentumSphere(1));
EE = patch(ax1, getEnergyEllipsoid(R));
ax1 = drawAxes(ax1);
MS.EdgeColor = 'blue'; MS.FaceColor = 'blue';
MS.FaceAlpha = 0.3; MS.EdgeAlpha = 0.5;
EE.EdgeColor = 0.4 * [0 1 0]; EE.FaceColor = 'green';
EE.FaceAlpha = 0.6; EE.EdgeAlpha = 0.8;
ax1.XTick = []; ax1.YTick = []; ax1.ZTick = [];
view(130, 30); axis(ax1, 'equal'); ax1.Visible = 'off';

F2 = figure;
set(F2, 'Units', 'pixels', 'OuterPosition', [100,1600,800,800],...
    'Color', 'white');
ax2 = axes(F2); hold(ax2, 'on'); grid(ax2, 'off');
MS = patch(ax2, getMomentumSphere(1*1.7));
EE = patch(ax2, getEnergyEllipsoid(R));
ax2 = drawAxes(ax2);
MS.EdgeColor = 'blue'; MS.FaceColor = 'blue';
MS.FaceAlpha = 0.3; MS.EdgeAlpha = 0.5;
EE.EdgeColor = 0.4 * [0 1 0]; EE.FaceColor = 'green';
EE.FaceAlpha = 0.6; EE.EdgeAlpha = 0.8;
ax2.XTick = []; ax2.YTick = []; ax2.ZTick = [];
view(130, 30); axis(ax2, 'equal'); ax2.Visible = 'off';

F3 = figure;
set(F3, 'Units', 'pixels', 'OuterPosition', [100,1600,800,800],...
    'Color', 'white');
ax3 = axes(F3); hold(ax3, 'on'); grid(ax3, 'off');
MS = patch(ax3, getMomentumSphere(0.5*1.7));
EE = patch(ax3, getEnergyEllipsoid(R));
ax3 = drawAxes(ax3);
MS.EdgeColor = 'blue'; MS.FaceColor = 'blue';
MS.FaceAlpha = 0.3; MS.EdgeAlpha = 0.5;
EE.EdgeColor = 0.4 * [0 1 0]; EE.FaceColor = 'green';
EE.FaceAlpha = 0.6; EE.EdgeAlpha = 0.8;
ax3.XTick = []; ax3.YTick = []; ax3.ZTick = [];
view(130, 30); axis(ax3, 'equal'); ax3.Visible = 'off';

F4 = figure;
set(F4, 'Units', 'pixels', 'OuterPosition', [100,1600,800,800],...
    'Color', 'white');
ax4 = axes(F4); hold(ax4, 'on'); grid(ax4, 'off');
MS = patch(ax4, getMomentumSphere(0.3*1.7));
EE = patch(ax4, getEnergyEllipsoid(R));
ax4 = drawAxes(ax4);
MS.EdgeColor = 'blue'; MS.FaceColor = 'blue';
MS.FaceAlpha = 0.3; MS.EdgeAlpha = 0.5;
EE.EdgeColor = 0.4 * [0 1 0]; EE.FaceColor = 'green';
EE.FaceAlpha = 0.6; EE.EdgeAlpha = 0.8;
ax4.XTick = []; ax4.YTick = []; ax4.ZTick = [];
view(130, 30); axis(ax4, 'equal'); ax4.Visible = 'off';


L = linspace(0.7, 1.9, 10); L = [L 1/0.85]; L = sort(L);
[X, Y, Z] = meshgrid(linspace(-1, 1, 100));
S1 = X.^2 + Y.^2 + Z.^2;
S2 = X.^2/R(1) + Y.^2/R(2) + Z.^2/R(3);
F5 = figure;
set(F5, 'Units', 'pixels', 'OuterPosition', [100,1600,800,800],...
    'Color', 'white');
ax5 = axes(F5); hold(ax5, 'on'); grid(ax5, 'off');
MS = patch(ax5, getMomentumSphere(1));
for i = 1:length(L)
    h = isocurve3(X, Y, Z, S1, S2, 1, L(i), 'LineWidth', 2, 'Color', 'black');end
ax5 = drawAxes(ax5);
MS.EdgeColor = 'black'; MS.FaceColor = 'white';
MS.FaceAlpha = 0.9; MS.EdgeAlpha = 1;
ax5.XTick = []; ax5.YTick = []; ax5.ZTick = [];
view(130, 30); axis(ax5, 'equal'); ax5.Visible = 'off';

exportgraphics(F1, 'P1.pdf', 'ContentType','auto','Resolution', 800);
exportgraphics(F2, 'P2.pdf', 'ContentType','auto','Resolution', 800);
exportgraphics(F3, 'P3.pdf', 'ContentType','auto','Resolution', 800);
exportgraphics(F4, 'P4.pdf', 'ContentType','auto','Resolution', 800);
exportgraphics(F5, 'P5.pdf', 'ContentType','auto','Resolution', 800);

function [ P ] = getMomentumSphere(H)

    [X, Y, Z] = sphere(20);
    X = H * X; Y = H * Y; Z = H * Z;
    P = surf2patch(X, Y, Z);

end

function [ P ] = getEnergyEllipsoid(R)

    [X, Y, Z] = ellipsoid(0, 0, 0, R(1), R(2), R(3), 20);
    P = surf2patch(X, Y, Z);

end

function [ ax, an ] = drawAxes(ax)

    Qx  = quiver3(ax, 0, 0, 0, 2, 0, 0, 0); 
    Qy  = quiver3(ax, 0, 0, 0, 0, 2, 0, 0); 
    Qz  = quiver3(ax, 0, 0, 0, 0, 0, 2, 0); 
    Qx.LineWidth = 1.5; Qx.MaxHeadSize = 0.3; Qx.Color = 'red'; 
    Qy.LineWidth = 1.5; Qy.MaxHeadSize = 0.3; Qy.Color = 'blue'; 
    Qz.LineWidth = 1.5; Qz.MaxHeadSize = 0.3; Qz.Color = 'green'; 
    Q = [Qx Qy Qz];
    an_x = text(2, 0, 0, '$H_1$','interpreter','latex',...
        'VerticalAlignment','bottom','HorizontalAlignment','right');
    an_y = text(0, 2, 0, '$H_2$','interpreter','latex');
    an_z = text(0, 0, 2, '$H_3$','interpreter','latex',...
        'VerticalAlignment', 'bottom');
    an = [an_x an_y an_z];
    ax.XLim = [-2 2]; ax.YLim = [-2 2]; ax.ZLim = [-2 2];

end
