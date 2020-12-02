function [ C ] = linearIsotropicElasticityTensor(E, nu)

lambda = nu * E / (1+nu) / (1-2*nu);
mu = E / 2 / (1+nu);

C   = zeros(3,3,3,3);                   % Elasticity Tensor
for i = 1:3
    for j = 1:3
        for k = 1:3
            for l = 1:3
                C(i,j,k,l) = lambda * (i==j)*(k==l) ...
                    + mu * ((i==k)*(j==l) + (i==l)*(j==k));
            end
        end
    end
end


end