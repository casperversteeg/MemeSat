%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   International Geomagnetic Reference Field
%   Written by: Casper Versteeg
%   Duke University
%   2021/01/04
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

IGRF13  = readcell("igrf13coeffs.txt", 'NumHeaderLines', 4);    % Read
gh      = IGRF13(:,1);                                          % Coef
Nm      = cell2mat(IGRF13(:,2:3));                              % Index
IGRF13  = cell2mat(IGRF13(:,4:end-1));                          % Value

a       = 6371.2;                                               % km
r       = a; %+ [0 0.1];
t       = 0;
phi     = -180:1:180;
theta   = 0:-1:-180;
[PHI, TH, R] = meshgrid(phi, theta, r);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V   = 0;
% SP  = legendre(max(Nm(:,1)), cos(TH), 'sch');

for k = 1:length(Nm)
    n = Nm(k,1);
    m = Nm(k,2);
    SP  = legendre(n, cosd(TH), 'sch');
    if strcmp(gh(k), "g")
        V = V + ((a./R).^(n+1) * IGRF13(k,end) ...
            .* cosd(m * PHI) .* squeeze(SP(m+1,:,:,:)));
    elseif strcmp(gh(k), "h")
        V = V + ((a./R).^(n+1) * IGRF13(k,end) ...
            .* sind(m * PHI) .* squeeze(SP(m+1,:,:,:)));
    else
        assert(false, "Unrecognized coefficient");
    end
end

V = a*V;
[Bx, By] = gradient(V, phi, theta);
Bx = -Bx; By = -By;
TH = TH + 90;
B = sqrt(Bx.^2 + By.^2);
% Bx = Bx./B; By = By./B; 
contour(PHI, TH, B, 50); shading interp; hold on;
% quiver(PHI, TH, Bx, By);
colormap('jet');
colorbar;