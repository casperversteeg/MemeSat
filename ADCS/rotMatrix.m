function R = rotMatrix(angle, ax)

if nargin < 2
    error(message('MATLAB:narginchk:notEnoughInputs'));
end
assert(ax == 1 || ax == 2 || ax == 3, ...
    "Rotation axis must be either 1, 2, or 3 (resp. x, y, z)");

R = eye(3);
A = [cosd(angle) -sind(angle); sind(angle), cosd(angle)];
switch(ax)
    case 1
        R(2:3, 2:3) = A;
        return;
    case 2
        R([1 3], [1 3]) = transpose(A);
        return;
    case 3
        R(1:2, 1:2) = A;
        return;
end


end