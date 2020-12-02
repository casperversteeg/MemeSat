clear all; close all; clc;

Bs = 0.027;
Br = 0.004;
Hc = 12;
% Bs = 0.74;
% Br = 0.35;
% Hc = 0.96;
Hlim = 25.8;

p = 1/Hc * tan(pi*Br/2/Bs);
Bhyst = @(H, s) 2/pi * Bs * atan(p * (H + (-1)^(s+1) * Hc));

x1 = -Hlim:1e-2:Hlim;
x2 = fliplr(x1);

subplot(1,2,1);
plot([x1, x2, x1(1)], [Bhyst(x1, 0), Bhyst(x2, 1), Bhyst(x1(1),0)])
grid on;

Bs = 0.74;
Br = 0.35;
Hc = 0.96;

p = 1/Hc * tan(pi*Br/2/Bs);
Bhyst = @(H, s) 2/pi * Bs * atan(p * (H + (-1)^(s+1) * Hc));

subplot(1,2,2);
plot([x1, x2, x1(1)], [Bhyst(x1, 0), Bhyst(x2, 1), Bhyst(x1(1),0)])
grid on;