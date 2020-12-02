clear all; close all; clc;
S = load('one-node');
R = 6873; h = 200;
sigma = 5.67e-8;
QsolH = 1414; QsolL = 1322;

beta = 0:3:90; Beta = asind(R/(R+h));
A3U = 0.33*0.1; A1U = 0.1*0.1;
Ai33 = 2e-3*sqrt(2)*0.33; Ai11 = 2e-3*sqrt(2)*0.11;
Acond = [-(2*Ai11+2*Ai33) Ai11 Ai11 0 Ai33 Ai33; Ai11 -4*Ai11 0 Ai11 Ai11 Ai11;Ai11 0 -4*Ai11 Ai11...
    Ai11 Ai11; 0 Ai11 Ai11 -(2*Ai11+2*Ai33) Ai33 Ai33; Ai33 Ai11 Ai11 Ai33 -(2*Ai11+2*Ai33) 0; Ai33...
    Ai11 Ai11 Ai33 0 -(2*Ai11+2*Ai33)];
m = 4; Qgen = 15.71;
Atotal = 4*A3U+2*A1U; m3 = m*A3U/Atotal; m1 = m*A1U/Atotal;
Qgen3 = Qgen*A3U/Atotal; Qgen1 = Qgen*A1U/Atotal;
Qgen = [Qgen3; Qgen1; Qgen1; Qgen3; Qgen3; Qgen3];
cp = 896; k = 400;

absorp3U = 0.983; absorp1U = 0.96; 
emiss3U = 0.961; emiss1U = 0.91;

Period = 92; Period = Period * 60;
N = 5;
dt = 1; t = 0:dt:N*Period; 

Ti = 293.15; 
%matrix order goes [zenith; nv; pv; nad; N; S];
TL = [Ti*ones(6,1), zeros(6, length(t)-1)]; TH = TL;
TzenH = []; TzenL = []; TnvH = []; TnvL = []; TnadH = []; TnadL = [];
TNH = []; TNL = []; TSH = []; TSL = []; TpvH = []; TpvL = [];

for i = 1:length(beta)
    if beta(i) < Beta
        fE = 1/180*acosd(sqrt(h^2+2*R*h)/((R+h)*cosd(beta(i))));
    else
        fE = 0;
    end
    if beta(i) < 30
        a = 0.14;                                   % -
        qIR = 228;                                 % W*m^-2
    else
        a = 0.19;                                   % -
        qIR = 218;                                 % W*m^-2
    end
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
    
    QH = zeros(6,length(t)); QL = QH;
    for j = 1:length(t)-1
        QL(:,j) = [Fzen(t(j))*A3U*absorp3U; Fnv(t(j))*A1U*absorp1U;...
            Fpv(t(j))*A1U*absorp1U; (Fnad(t(j))+a*s(t(j)))*A3U*absorp3U;...
            FN(t(j))*A3U*absorp3U; 0]*QsolL + Qgen+[0;0;0;qIR*A3U;0;0];
        QL(:,j) = QL(:,j)+k*Acond*TL(:,j);
        QL(:,j) = QL(:,j)-sigma*[emiss3U*A3U; emiss1U*A1U; emiss1U*...
            A1U; emiss3U*A3U; emiss3U*A3U; emiss3U*A3U].*(TL(:,j).^4);
        QH(:,j) = [Fzen(t(j))*A3U*absorp3U; Fnv(t(j))*A1U*absorp1U;...
            Fpv(t(j))*A1U*absorp1U; (Fnad(t(j))+a*s(t(j)))*A3U*absorp3U;...
            FN(t(j))*A3U*absorp3U; 0]*QsolH + Qgen+[0;0;0;qIR*A3U;0;0];
        QH(:,j) = QH(:,j)+k*Acond*TH(:,j);
        QH(:,j) = QH(:,j)-sigma*[emiss3U*A3U; emiss1U*A1U; emiss1U*...
            A1U; emiss3U*A3U; emiss3U*A3U; emiss3U*A3U].*(TH(:,j).^4);
        TL(:,j+1) = TL(:,j) + dt./[m3; m1; m1; m3; m3; m3]./cp.*QL(:,j);
        TH(:,j+1) = TH(:,j) + dt./[m3; m1; m1; m3; m3; m3]./cp.*QH(:,j);
    end
    TzenL = [TzenL; TL(1,:)]; TzenH = [TzenH; TH(1,:)];
    TnvL = [TnvL; TL(2,:)]; TnvH = [TnvH; TH(2,:)];
    TpvL = [TpvL; TL(3,:)]; TpvH = [TpvH; TH(3,:)];
    TnadL = [TnadL; TL(4,:)]; TnadH = [TnadH; TH(4,:)];
    TNL = [TNL; TL(5,:)]; TNH = [TNH; TH(5,:)];
    TSL = [TSL; TL(6,:)]; TSH = [TSH; TH(6,:)];
end

Tmax = [max(TzenH,[],2) max(TnvH, [],2) max(TpvH,[],2), max(TnadH,[],2)...
    max(TNH,[],2) max(TSH,[],2)];
Tmin = [min(TzenL,[],2) min(TnvL, [],2) min(TpvL,[],2), min(TnadL,[],2)...
    min(TNL,[],2) min(TSL,[],2)];
MAX = max(Tmax,[],2)+11; MIN = min(Tmin,[],2)-11;

figure(1);
[TIME, BETA] = meshgrid(t, beta);
surf(TIME, BETA, TzenH);
shading interp
xlabel('Time, $t$ (s)','interpreter','latex');
ylabel('Beta angle, $\beta$ ($^{\circ}$)','interpreter','latex');
zlabel('Temperature, $T$ (K)','interpreter','latex');
ax = gca; ax.TickLabelInterpreter = 'latex';

figure(2);
yyaxis left
h1 = plot(beta, Tmin-273.15,'.');hold on
h2 = plot(S.beta, S.MinTL-273.15);hold off
ylabel('Low temperature extrema ($^{\circ}$C)','interpreter','latex');
ylim([-30 80]);
yyaxis right
plot(beta, Tmax-273.15,'.');hold on
plot(S.beta, S.MaxTH-273.15);
h3= plot(beta, MAX-273.15,'-k',beta,MIN-273.15,'-k');hold off
ylim([-30 80]);
ylabel('High temperature extrema ($^{\circ}$C)','interpreter','latex');
xlabel('Beta angle ($^{\circ}$)','interpreter','latex');
grid on; ax = gca; ax.TickLabelInterpreter = 'latex';
L = legend([h2, h1(1), h3(1)], 'Single-node model','Six-node model','2-$\sigma$ Confidence');
set(L,'interpreter','latex','location','northwest');