function [ N, grad_N ] = getLinearShapeFunction(x, i)

if i == 1
    N = 0.5 * (1 - x);
    grad_N = -0.5;
elseif i == 2
    N = 0.5 * (1 + x);
    grad_N = 0.5;
else
    error(message('MATLAB:badsubscript'));
end

end