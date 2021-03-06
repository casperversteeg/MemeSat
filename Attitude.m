%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Master Controller Script
%   Written by: Casper Versteeg
%   Duke University
%   2020/09/13
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; addpath(genpath("./ADCS/"));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

% Settings:
genVid  = false;

% Model constants:
N       = 10;                    % Number of orbits to simulate

% Two-line orbital elements (ISS, cite [1])
% S = ['1 25544U 98067A   20268.74436096  .00016717  00000-0  10270-3 0  9048'; ...
%      '2 25544  51.6430 215.8325 0000565  70.4425 289.6786 15.48939435  7447'];

S = ['1 90039U      0   12268.58971383  .00002482  00000-0  23852-3 0  0208';...
     '2 90039  64.6731 007.9077 0219372 286.2692 203.1718 14.79135411  1569'];

E = Earth;
SC = CCSWE;
SC.initializeAngularVelocity([0.17; -0.97; 2.93]*pi/180);
F = Orbit(S, E, SC);
F.inclination = 2;


optn = odeset('RelTol', 1e-8);
% optn.Refine = 1;
optn.InitialStep = 1e-5;
optn.MaxStep = 0.1;
%optn.AbsTol = 1e-12;

% f = figure;
% ax1 = subplot(1,2,1);
% F.addToAxes(ax1);
% E.magneticField.addToAxes(1.2*E.radius ,ax1);
% 
% ax2 = subplot(1,2,2);
% SC.addToAxes(ax2);

figure;
F.fly(N, optn, @ode23);
% F.fly(N, optn, @ode45);
f = figure; ax = axes(f); hold(ax, 'on'); grid(ax, 'on');
L = min([length(SC.solnAngularVelocity) length(SC.solnTime)]); 
plot(ax, SC.solnTime(1:L)/3600, SC.solnAngularVelocity(:, 1:L)*180/pi);
plot(ax, SC.solnTime(1:L)/3600, vecnorm(SC.solnAngularVelocity(:, 1:L)*180/pi), 'k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
optn = odeset('MaxStep',10);

soln = ode45(@(t, y) satelliteEOM(t, y, Sat, Flight), ...
    [0 N * Flight.sec_per_orbit], ...
    [Sat.attitude_quaternion; Sat.omega], optn);

% subplot(2,1,1);
plot(soln.x / 3600 /24, soln.y(5:7, :)/pi,...
     soln.x / 3600 /24, vecnorm(soln.y(5:7,:)/pi), 'k'); grid on;
ax = gca; ax.TickLabelInterpreter = 'latex';
xlabel('$t$ (days)', 'interpreter','latex');
ylabel('$\omega$ ($\mathrm{deg\cdot s^{-1}}$)','interpreter','latex');
L = legend('$\omega_x$','$\omega_y$','$\omega_z$', '$|\vec{\omega}|$');
set(L,'interpreter','latex','location','best');

% subplot(2,1,2);
% plot(soln.x / Flight.sec_per_orbit, computeAngleError(soln, Sat, Flight)); 
% ax = gca; ax.TickLabelInterpreter = 'latex'; grid on;
% xlabel('$t$ (orbits)', 'interpreter','latex');
% ylabel('Angle error, $\delta \theta$ ($\mathrm{rad}$)',...
%     'interpreter','latex');

%%

% f = figure;
% set(f, 'Units','pixels', 'OuterPosition', [100,1150,800,450], ...
%     'Color', 'white');
% ax1 = drawOrbit(subplot(1,2,1), Earth, Flight);
% ax2 = drawEarthMagneticField(subplot(1,2,2), 1.2*RE, Earth);


%%
% Frames array:
frames = struct('cdata', [],'colormap',[]);

F   = figure;
set(F, 'Units', 'pixels', 'OuterPosition', [100,1600,800,450],...
    'Color', 'white');
ax1 = subplot(1,2,1);
drawEarth(ax1, Earth);
hold(ax1, 'on'); 
R = quiver3(ax1, 0, 0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize',0.3);
xlabel(ax1,'$x$','interpreter','latex'); 
ylabel(ax1,'$y$','interpreter','latex');
zlabel(ax1,'$z$','interpreter','latex');
title(ax1, "MemeSat Orbit", 'interpreter','latex');
ax1.XTick = [];
ax1.YTick = [];
ax1.ZTick = [];
view(130, 30); axis(ax1, 'equal');
ax1.XLim = 1.5*RE*[-1 1]; ax1.YLim = 1.5*RE*[-1 1]; ax1.ZLim = 1.5*RE*[-1 1];

ax2 = subplot(1,2,2); 
[S, Q, an] = drawSatellite(ax2, Sat);
hold(ax2, 'on');
B = quiver3(ax2, 0, 0, 0, 0, 0 ,0, 1e3);
B.LineWidth = 2; B.MaxHeadSize = 0.3; B.Color = 'magenta';
T = quiver3(ax2, 0, 0, 0, 0, 0 ,0, 1e5);
T.LineWidth = 2; T.MaxHeadSize = 0.3; T.Color = 'black';
view(130, 30); axis(ax2, 'equal');
xlabel(ax2,'$x$','interpreter','latex'); 
ylabel(ax2,'$y$','interpreter','latex');
zlabel(ax2,'$z$','interpreter','latex');
title(ax2, 'MemeSat','interpreter','latex');
ax2.TickLabelInterpreter = 'latex';
ax2.XLim = sqrt(3)*Sat.w_max*[-1 1]; 
ax2.YLim = sqrt(3)*Sat.w_max*[-1 1]; 
ax2.ZLim = sqrt(3)*Sat.w_max*[-1 1];
an_B = text(0,0,0, '$\vec{B}_\mathrm{\oplus}$',...
        'interpreter','latex','VerticalAlignment', 'bottom');
an_T = text(0,0,0, '$\vec{\tau}$',...
    'interpreter','latex','VerticalAlignment', 'bottom');

for i = 1:20:length(soln.x)
    q = soln.y(1:4, i); q = q/vecnorm(q);
    A = attitudeMatrixFromQuaternion(q);
    [R.UData, R.VData, R.WData] = satellitePositionECEF(Flight, soln.x(i));
    [th, ph, rh] = cart2sph(R.UData, R.VData, R.WData);
    [B.UData, B.VData, B.WData] = magneticDipole(ph, th, rh);
    an_B.Position = 1e3 * [B.UData, B.VData, B.WData];
    S.Vertices = (A * Sat.model.Vertices')';
    for j = 1:3
        Q(j).UData = A(1,j) * 1.5 * Sat.w_max;
        Q(j).VData = A(2,j) * 1.5 * Sat.w_max;
        Q(j).WData = A(3,j) * 1.5 * Sat.w_max;
        an(j).Position = [Q(j).UData, Q(j).VData, Q(j).WData];
    end
    if length(Q) == 4
        Brot = A * Sat.perm_mag * 1e-2;
        Q(4).UData = Brot(1);
        Q(4).VData = Brot(2);
        Q(4).WData = Brot(3);
        an(4).Position = Brot*1e1;
    end
    torque = cross([Q(4).UData, Q(4).VData, Q(4).WData], [B.UData, B.VData, B.WData]);
    T.UData = torque(1);
    T.VData = torque(2);
    T.WData = torque(3);
    an_T.Position = 1e2 * torque;
    drawnow;
    if genVid
        frames(end+1) = getframe(F);
    end
end

if genVid
    frames(1) = [];
    video = VideoWriter('MemeSatPassiveMagnet.avi','Uncompressed AVI');
    video.FrameRate = 30;
    open(video);
    writeVideo(video, frames);
    close(video);
end


%% References
% [1]     https://www.heavens-above.com/orbit.aspx?satid=25544
