%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Master Controller Script
%   Written by: Casper Versteeg
%   Duke University
%   2020/11/24
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; addpath("./FE", "./draw");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

% Model constants:
Sat = getSimple1U;

rho = 2700;                             % Density
E   = 69e9;                             % Young's modulus
nu  = 0.3;                              % Poisson's ratio

C = linearIsotropicElasticityTensor(E, nu);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[K, M] = assembleKMmatrix(rho, C, Sat)

f = figure; 
ax1 = subplot(1, 3, 1);
[S1, Q1, an1] = drawSatellite(ax1, Sat);

ax2 = subplot(1, 3, 2);
[S2, Q2, an2] = drawSatellite(ax2, Sat);

ax3 = subplot(1, 3, 3);
[S3, Q3, an3] = drawSatellite(ax3, Sat);
