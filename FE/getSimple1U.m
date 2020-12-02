function [ Sat ] = getSimple1U()

wx_sat  = 0.1;                  % Dimension in x-direction,     [m]
wy_sat  = 0.1;                  % Dimension in y-direction,     [m]
wz_sat  = 0.1;                  % Dimension in z-direction,     [m]

% Vertex coordinates v = [x y z];
V   = [1  1  1; -1  1  1; -1 -1  1; 1 -1  1; ...
       1  1 -1; -1  1 -1; -1 -1 -1; 1 -1 -1];
V(:,1) = V(:,1) * wx_sat/2;
V(:,2) = V(:,2) * wy_sat/2;
V(:,3) = V(:,3) * wz_sat/2;
% Connectivity array of faces F = [v1 v2 v3 v4]
C   = [1 2 3 4; 1 4 8 5; 5 6 7 8; 2 3 7 6; 1 2 6 5; 3 4 8 7];

w_max = max([wx_sat wy_sat wz_sat])/2;

f = figure;
ax = axes(f);
P1 = patch(ax, 'Faces', C, 'Vertices', V);
P = copy(P1);
P.EdgeColor = 'black';
P.FaceColor = [1 1 1] * 0.9;
P.FaceAlpha = 0.3;
close(f);

Sat     = struct('model', P, 'w_max', w_max);
end