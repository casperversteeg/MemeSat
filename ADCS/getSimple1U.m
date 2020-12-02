function [ Sat ] = getSimple1U()

wx_sat  = 0.1;                  % Dimension in x-direction,     [m]
wy_sat  = 0.1;                  % Dimension in y-direction,     [m]
wz_sat  = 0.1;                  % Dimension in z-direction,     [m]
M       = 1;                    % Total satellite mass,         [kg]

mu0     = 4e-7*pi;              % Permeability of vacuum,       [H/m]
Hc      = 12;                   % Coersive force,               [A/m]
Br      = 0.004;                % Remanence,                    [T]
Bs      = 0.027;                % Saturation induction,         [T]
p       = 1/Hc*tan(pi*Br/2/Bs); % Stretching factor,            [-]
h_hat   = [0; 1; 0];            % Hysteresis rod axial direction vector

Hyst    = struct('mu0', mu0, 'Hc', Hc, 'Br', Br, 'Bs', Bs, 'p', p, ...
    'h_hat', h_hat);

m_hat   = [0; 0; 1];            % Sat. magnet unit vector       [-]
m_sat   = m_hat * 0.29;         % Sat. permanent magnet vector, [A.m2]
% Vertex coordinates v = [x y z];
V   = [1  1  1; -1  1  1; -1 -1  1; 1 -1  1; ...
       1  1 -1; -1  1 -1; -1 -1 -1; 1 -1 -1];
V(:,1) = V(:,1) * wx_sat/2;
V(:,2) = V(:,2) * wy_sat/2;
V(:,3) = V(:,3) * wz_sat/2;
% Connectivity array of faces F = [v1 v2 v3 v4]
C   = [1 2 3 4; 1 4 8 5; 5 6 7 8; 2 3 7 6; 1 2 6 5; 3 4 8 7];
% Mass moments of inertia:
Ixx     = M * (wy_sat^2 + wz_sat^2)/12;
Iyy     = M * (wx_sat^2 + wz_sat^2)/12;
Izz     = M * (wx_sat^2 + wy_sat^2)/12;
I       = diag([Ixx Iyy Izz]);  % Moment of inertia tensor,  [kg.m^2]

rot     = [0;0;0;1];
omega   = [0;0;0];

w_max = max([wx_sat wy_sat wz_sat])/2;

f = figure;
ax = axes(f);
P1 = patch(ax, 'Faces', C, 'Vertices', V);
P = copy(P1);
P.EdgeColor = 'black';
P.FaceColor = [1 1 1] * 0.9;
P.FaceAlpha = 0.3;
close(f);

Sat     = struct('model', P, 'mass_moi', I, 'mass', M,...
    'perm_mag', m_sat, 'w_max', w_max, 'omega', omega, ...
    'attitude_quaternion', rot, 'hyst_rod', Hyst, 'B', [0;0;0]);
end