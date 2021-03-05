%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ode45 Example
%   Written by: Casper Versteeg
%   Duke University
%   2020/12/03
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

ode1 = @(t, x) exp(-t);         % x_dot = exp(-t) --> x = -exp(-t) + C
ode2 = @(t, x) [-x(2) - x(1) + sin(pi*t); x(1)]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

optn = odeset('OutputFcn', @customodeprint);
[T1,X1] = ode45(ode1, [0 10], 0, optn);
[T2,X2] = ode45(ode2, [0 20], [0; 0]);

% subplot(1,2,1);
% plot(T1, X1);
% 
% subplot(1,2,2);
% plot(T2, X2(:,2));
