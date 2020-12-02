function [ E ] = drawEarth(ax, Earth)

if nargin < 2
    error(message('MATLAB:narginchk:notEnoughInputs'));
end

R = 1.5*(Earth.radius);

S = copy(Earth.model);
S.Parent = ax;
hold(ax, 'on');
Qx  = quiver3(ax, 0, 0, 0, R, 0, 0, 0); 
Qy  = quiver3(ax, 0, 0, 0, 0, R, 0, 0); 
Qz  = quiver3(ax, 0, 0, 0, 0, 0, R, 0); 
Qx.LineWidth = 2; Qx.MaxHeadSize = 0.3; Qx.Color = 'red'; 
Qy.LineWidth = 2; Qy.MaxHeadSize = 0.3; Qy.Color = 'blue'; 
Qz.LineWidth = 2; Qz.MaxHeadSize = 0.3; Qz.Color = 'green'; 
an_x = text(R, 0, 0, '$\Upsilon$','interpreter','latex',...
    'VerticalAlignment','bottom','HorizontalAlignment','right');
an_y = text(0, R, 0, '$y$','interpreter','latex');
an_z = text(0, 0, R, '$z$','interpreter','latex','VerticalAlignment',...
    'bottom');
hold(ax, 'off');

E = struct('model', S, 'Qx', Qx, 'Qy', Qy, 'Qz', Qz);

end