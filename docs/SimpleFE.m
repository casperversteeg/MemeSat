%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   
%   Written by: Casper Versteeg
%   Duke University
%   2021/01/29
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CREDITS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%

N1  = @(x, y) 0.25 * (1-x).*(1-y);
N1x = @(x, y) 0.25 * -(1-y);
N1y = @(x, y) 0.25 * -(1-x);

N2  = @(x, y) 0.25 * (1+x).*(1-y);
N2x = @(x, y) 0.25 * (1-y);
N2y = @(x, y) 0.25 * -(1+x);

N3  = @(x, y) 0.25 * (1+x).*(1+y);
N3x = @(x, y) 0.25 * (1+y);
N3y = @(x, y) 0.25 * (1+x);

N4  = @(x, y) 0.25 * (1-x).*(1+y);
N4x = @(x, y) 0.25 * -(1+y);
N4y = @(x, y) 0.25 * (1-x);

N   = @(x, y) [N1(x,y), N2(x,y), N3(x,y), N4(x,y)];
B   = @(x, y) [N1x(x,y), N2x(x,y), N3x(x,y), N4x(x,y);
               N1y(x,y), N2y(x,y), N3y(x,y), N4y(x,y)];

x   = -1:1e-1:1; y = x;
[X,Y] = meshgrid(x,y);

qp  = [-1, -1; 1, -1; 1, 1; -1, 1]./sqrt(3);
wi  = [     1;     1;    1;     1];
nqp = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%


F = figure;
ax = axes(F); hold(ax, 'on'); grid(ax, 'on'); axis(ax, 'equal');
[Q4, ax] = getQuad4Elem(ax);
ax.XLim = 1.1 * [-1 3]; ax.YLim = 1.1 * [-1 1]; ax.ZLim = [-0.1 1.1];
xlabel(ax, '$x$','interpreter','latex');
ylabel(ax, '$y$','interpreter','latex');
ax.TickLabelInterpreter = 'latex';

%%
J = 0;
for i = 1:nqp
    plot(ax, qp(i,1), qp(i,2), 'rx');
    
end

%%
K = zeros(6, 6);
for e = 1:2
    Ke = zeros(4, 4);
    for i = 1:nqp
        J = B(qp(i,1), qp(i,2)) * Q4.Vertices(Q4.Faces(e,:),:);
        j = det(J);
        Ke = Ke + ((B(qp(i,1), qp(i,2))' * B(qp(i,1), qp(i,2))) * j * wi(i));
    end
    for i = 1:4
        for j = 1:4
            idof = Q4.Faces(e, i);
            jdof = Q4.Faces(e, j);
            K(idof, jdof) = K(idof, jdof) + Ke(i,j);
        end
    end
end

k = K; 
k(4,:) = []; k(:,4) = [];
k(1,:) = []; k(:,1) = [];
f = -K([2:3 5:6], 4);
u = k\f;

u = [0; u(1:2); 1; u(3:4)];

U = N1(X,Y) * u(1) + N2(X,Y) * u(2) + N3(X,Y) * u(3) + N4(X,Y) * u(4);

Q4.FaceVertexCData = u;
Q4.FaceColor = 'interp';

function [ P, ax ] = getQuad4Elem(ax)

    V = [-1, -1; 1, -1; 1, 1; -1, 1; 3 -1; 3 1];
    F = [1 2 3 4;
         2 5 6 3];
    P = patch(ax, 'Faces', F, 'Vertices', V);
    P.FaceAlpha = 0.3;
    P.EdgeColor = 'black';
    P.Marker = '.';
    P.MarkerSize = 15;
    view(45, 30);
    
end

