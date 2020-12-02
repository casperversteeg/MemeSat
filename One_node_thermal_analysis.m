%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Written by : Casper Versteeg
%   Date: 1/28/2018
%   University of Georgia SSRL
% 
%   R = Earth radius; h = orbit altitude
%   fE = fraction of orbit spent in eclipse
%   beta = beta angle
%   d = diagonal length of 3U side and diameter of spherical model
%   A = surface area of the spherical profile
%   N = number of orbits to simulate
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 6873; h = 400;                                  % km
sigma = 5.67e-8;                                    % W*m^-2*K^-4

beta = 0:1e-0:90; Beta = asind(R/(R+h));            % degrees

SolH = 1414; SolL = 1322;                           % W*m^-2
d = 0.2111;                                         % m
A = pi/4*d^2;                                       % m^2
As = 4*pi*(d/2)^2;                                  % m^2
Q_solH = SolH*A; Q_solL = SolL*A;                   % W

m = 4;                                              % kg
c_p = 896;                                          % J*kg^-1*K^-1
SS_absorp = 0.96;                                   % -
SS_emiss = 0.90;                                    % -

Qgen = 15.71;                                       % W
%Qgen = 0;

Period = 92; Period = Period * 60;                  % min; s
N = 5;                                              % - Number of orbits
dt = 1; t = 0:dt:N*Period;                        % s*(min)^-1; min

Ti = 293.15;                                        % K
T_LOW = [Ti zeros(1,length(t)-1)]; T_HIGH = T_LOW;  % K
T_LPLOT = zeros(length(beta), length(t));
T_HPLOT = T_LPLOT;
%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(beta)
    if beta(i) < Beta
        fE = 1/180*acosd(sqrt(h^2+2*R*h)/((R+h)*cosd(beta(i))));
    else
        fE = 0;
    end
    if beta(i) < 30
        a = 0.14;                                   % -
        q_IR = 228;                                 % W*m^-2
    else
        a = 0.19;                                   % -
        q_IR = 218;                                 % W*m^-2
    end
    
    % In-sun correction vector, is a logical that turns on or off the solar
    % heating. The floor(t/Period)*Period is a correction factor that tells
    % the logic which orbit it is in so that it can keep cycling as opposed
    % to staying on after the first orbit.
    s = (Period/2*(1-fE)+floor(t/Period)*Period>t)|(Period/2*(1+fE)...
        +floor(t/Period)*Period<t);
    
    QIR = q_IR*A;                                   % W
    Q_total_solH = (1+a)*Q_solH.*s;                 % W -- only in sun
    Q_total_solL = (1+a)*Q_solL.*s;                 % W -- else is zero (0)
    
    QradL = As*sigma*SS_emiss*T_LOW(1)^4;
    QradH = As*sigma*SS_emiss*T_HIGH(1)^4;
    Q_totalH = Q_total_solH + QIR + Qgen;
    Q_totalL = Q_total_solL + QIR + Qgen;
    
    for k = 2:length(t)
        T_LOW(k) = T_LOW(k-1) + dt/m/c_p*(Q_totalL(k)-QradL);
        T_HIGH(k) = T_HIGH(k-1) + dt/m/c_p*(Q_totalH(k)-QradH);
        
        QradL = As*sigma*SS_emiss*T_LOW(k)^4;
        QradH = As*sigma*SS_emiss*T_HIGH(k)^4;
    end
    T_LPLOT(i,:) = T_LOW;
    T_HPLOT(i,:) = T_HIGH;
end
figure(1);
plot(beta, fE); xlabel('beta angle (deg)'); grid on;
ylabel('fraction spent in eclipse');
title('Time spent in eclipse Vs. beta angle');

figure(2);
[tPLOT, BETA] = meshgrid(t, beta);
subplot(1,2,1);
surf(tPLOT, BETA, T_LPLOT); colormap('winter');
shading interp;
xlim([0,t(end)]); ylim([0,90]);
xlabel('Time from launch (s)','interpreter','latex');
ylabel('Beta angle ($^{\circ}$)','interpreter','latex');
zlabel('Temperature (K)','interpreter','latex');
title('Cold Case Temperature Vs Time and Beta Angle','interpreter',...
    'latex');
ax = gca; ax.TickLabelInterpreter = 'latex';
subplot(1,2,2);
surf(tPLOT, BETA, T_HPLOT); colormap(gca, 'autumn');
shading interp;
xlim([0,t(end)]); ylim([0,90]);
xlabel('Time from launch (s)','interpreter','latex');
ylabel('Beta angle ($^{\circ}$)','interpreter','latex');
zlabel('Temperature (K)','interpreter','latex');
title('Hot Case Temperature Vs Time and Beta Angle','interpreter',...
    'latex');
ax = gca; ax.TickLabelInterpreter = 'latex';

MinTL = min(T_LPLOT,[],2);
MaxTH = max(T_HPLOT,[],2);
figure(3); 
yyaxis left
plot(beta, MinTL-273.15);
ylabel('Low temperature extreme ($^{\circ}$C)','interpreter','latex');
ylim([0 60]);
yyaxis right
plot(beta, MaxTH-273.15);
ylabel('High temperature extreme ($^{\circ}$C)','interpreter','latex');
ylim([0 60]);
xlabel('Beta angle ($^{\circ}$)','interpreter','latex');
grid on; ax = gca; ax.TickLabelInterpreter = 'latex';

save('one-node', 'MinTL', 'MaxTH', 'beta');