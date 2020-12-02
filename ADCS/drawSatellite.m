function [ S, Q, an ] = drawSatellite(ax, Sat, drawMagVec)

if nargin < 3
    drawMagVec = true;
    if nargin < 2
        error(message('MATLAB:narginchk:notEnoughInputs'));
    end
end

w_max = 1.5*Sat.w_max;
B = Sat.perm_mag;
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

if drawMagVec
    Bq = quiver3(ax, 0, 0, 0, B(1), B(2), B(3), 10);
    Bq.LineWidth = 2; Bq.MaxHeadSize = 0.3; Bq.Color = 'cyan';
    an_B = text(10*B(1), 10*B(2), 10*B(3), '$B_\mathrm{sat}$',...
        'interpreter','latex','VerticalAlignment', 'bottom');
    Q = [Q Bq];
    an = [an an_B];
end

end