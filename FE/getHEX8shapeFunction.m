function [ N, grad_N ] = getHEX8shapeFunction(x, i)

map     = [1 1 1;
           2 1 1;
           2 2 1;
           1 2 1;
           1 1 2;
           2 1 2;
           2 2 2 ;
           1 2 2];

[Nx, Bx] = getLinearShapeFunction(x(1), map(i, 1));
[Ny, By] = getLinearShapeFunction(x(2), map(i, 2));
[Nz, Bz] = getLinearShapeFunction(x(3), map(i, 3));

N = Nx * Ny * Nz;
grad_N = [Bx*Ny*Nz; Nx*By*Nz; Nx*Ny*Bz];

end