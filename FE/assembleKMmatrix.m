function [ K, M ] = assembleKMmatrix(rho, C, Sat)

qp = 1/sqrt(3)* [-1 -1 -1;
                  1 -1 -1;
                  1  1 -1;
                 -1  1 -1;
                 -1 -1  1;
                  1 -1  1;
                  1  1  1;
                 -1  1  1];
w = 1;

K = zeros(24, 24);
M = K;

for i = 1:8
    for j = 1:8
        [Ni, grad_Ni] = getHEX8shapeFunction(qp(i,:), j);
    end
end

end