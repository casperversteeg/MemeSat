function [ S, Q, an ] = drawSatellite(ax, Sat)

if nargin < 2
    error(message('MATLAB:narginchk:notEnoughInputs'));
end

w_max = 1.5*Sat.w_max;
S = copy(Sat.model);
S.Parent = ax;
hold(ax, 'on');
Qx  = quiver3(ax, 0, 0, 0, w_max, 0, 0, 0); 
Qy  = quiver3(ax, 0, 0, 0, 0, w_max, 0, 0); 
Qz  = quiver3(ax, 0, 0, 0, 0, 0, w_max, 0); 
Qx.LineWidth = 2; Qx.MaxHeadSize = 0.3; Qx.Color = 'red'; 
Qy.LineWidth = 2; Qy.MaxHeadSize = 0.3; Qy.Color = 'blue'; 
Qz.LineWidth = 2; Qz.MaxHeadSize = 0.3; Qz.Color = 'green'; 
Q = [Qx Qy Qz];
an_x = text(w_max, 0, 0, '$x$','interpreter','latex',...
    'VerticalAlignment','bottom','HorizontalAlignment','right');
an_y = text(0, w_max, 0, '$y$','interpreter','latex');
an_z = text(0, 0, w_max, '$z$','interpreter','latex',...
    'VerticalAlignment', 'bottom');
an = [an_x an_y an_z];

view(130, 30); axis(ax, 'equal');
xlabel(ax,'$x$','interpreter','latex'); 
ylabel(ax,'$y$','interpreter','latex');
zlabel(ax,'$z$','interpreter','latex');
title(ax, 'MemeSat','interpreter','latex');
ax.TickLabelInterpreter = 'latex';
ax.XLim = sqrt(3)*Sat.w_max*[-1 1]; 
ax.YLim = sqrt(3)*Sat.w_max*[-1 1]; 
ax.ZLim = sqrt(3)*Sat.w_max*[-1 1];


end