clear all; close all; clc;

% Check partition of unity
V = -[1  1  1; -1  1  1; -1 -1  1; 1 -1  1; ...
       1  1 -1; -1  1 -1; -1 -1 -1; 1 -1 -1];
   
for i = 1:8
    N = 0;
    grad_N = [0;0;0];
    for j = 1:8
        [n, b] = getHEX8shapeFunction(V(i,:), j);
        N = N + n;
        grad_N = grad_N + b;
    end
    if N ~= 1 || norm(grad_N) ~= 0
        error("Partition of Unity Test Failed");
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    