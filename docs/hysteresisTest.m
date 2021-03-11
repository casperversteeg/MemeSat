clear all; close all; clc;

L = 95; 
D = 1;
Hc = 0.3381;
Br = 6.0618e-4;
Bs = 0.3;
h_hat = [1;0;0];
q0 = 0;
p = 2;
mu0 = 4e-7*pi;
Hlim = 10*Hc;

volume = L*1e-3 * pi/4 * (D*1e-3)^2;
k = 1/Hc * tan(pi*Br/2/Bs);


H_lim = @(B, Hdot) 1/k * tan(pi/2 * B/Bs) - (-1)^(Hdot < 0) * Hc;
global dBdH ;

dBdH = @(B, H, Hdot) 2/pi * k * Bs * cos(pi/2*B/Bs)^2 * ((H - H_lim(B, Hdot))/2/Hc).^2;

% F = @(Bind, Bloc, Bdotloc) q0 + (1-q0)*(1/2/Hc *(Bloc/mu0 ...
%     - tan(pi*Bind/2/Bs)/k +(-1).^(Bdotloc < 0) * Hc)).^p;
% Bdotind = @(t, Bind, Bloc, Bdotloc) Bdotloc * (2*k*Bs/pi) ...
%     * cos(pi*Bind/2/Bs).^2 * F(Bind, Bloc, Bdotloc);

H = @(t) Hlim .* sin(2*pi*t);
dH = @(t) 2*pi *Hlim.*cos(2*pi*t);

optn = odeset('MaxStep', 0.001);
soln1 = ode45(@(t, B) dBdt(B, H(t), dH(t)), [0 2], 0, optn);
soln2 = ode45(@(t, B) dBdt(B, H(0.5*t), dH(0.5*t)), [0 2], 0, optn);

f = figure;
ax = axes(f); hold(ax,'on'); grid(ax, 'on');
P1 = plot(ax, 0, 0);
P2 = plot(ax, 0, 0);
for i = 1:length(soln1.x)
    P1.XData = H(soln1.x(1:i));
    P1.YData = soln1.y(1:i) * volume / mu0;
    drawnow;
end

for i = 1:length(soln2.x)
    P2.XData = H(soln2.x(1:i));
    P2.YData = soln2.y(1:i) * volume / mu0;
    drawnow;
end

function dBdt = dBdt(B, H, Hdot)
    global dBdH;
    dBdt = dBdH(B, H, Hdot) * Hdot;
    fprintf('function eval at B = %e\n', B);
end