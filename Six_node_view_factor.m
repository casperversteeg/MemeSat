clear all; clc;
N=1; Period = 60*92; dt = 1;
t = 0:dt:N*Period;
R = 6873; h = 400; i = 1;
beta(i) = 20;
fE = 1/180*acosd(sqrt(h^2+2*R*h)/((R+h)*cosd(beta)));

Fzen = @(ti) cos(2*pi/Period.*ti).*cosd(beta(i)).*((Period./4+...
        floor(ti./Period).*Period>ti)|(3*Period/4+floor(ti./Period)*Period<ti));
    Fnv = @(ti) sin(2*pi/Period.*ti).*cosd(beta(i)).*(ti<Period/2*(1-fE)+...
        floor(ti./Period)*Period);
    Fpv = @(ti) -sin(2*pi/Period.*ti).*cosd(beta(i)).*(ti>Period/2*(1+fE)+...
        floor(ti./Period)*Period);
    Fnad = @(ti) -cos(2*pi/Period.*ti).*cosd(beta(i)).*(((ti>Period/4+...
        floor(ti./Period)*Period)&(ti<Period/2*(1-fE)+floor(ti./Period)*...
        Period))|((ti>Period/2*(1+fE)+floor(ti./Period)*Period)&(ti<3*Period/...
        4+floor(ti./Period)*Period)));
    FN = @(ti) sind(beta(i)).*((Period/2*(1-fE)+floor(ti./Period)*Period>ti)...
        |(ti>Period/2*(1+fE)+floor(ti./Period)*Period));
    FS = 0;
    s = @(ti) (Period/2*(1-fE)+floor(ti/Period)*Period>ti)|(Period/2*(1+fE)...
        +floor(ti/Period)*Period<ti);
    
subplot(2,3,1); plot(t, Fzen(t)); title('F_{zenith}'); xlabel('t'); grid on;
subplot(2,3,2); plot(t, Fnv(t)); title('F_{-v}'); xlabel('t'); grid on;
subplot(2,3,3); plot(t, Fpv(t)); title('F_{+v}'); xlabel('t'); grid on;
subplot(2,3,4); plot(t, Fnad(t)); title('F_{nadir}'); xlabel('t'); grid on;
subplot(2,3,5); plot(t, FN(t)); title('F_{N/S}'); xlabel('t'); grid on;
subplot(2,3,6); plot(t, s(t)); title('s'); xlabel('t'); grid on;