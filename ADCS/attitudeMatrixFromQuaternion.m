function [ A ] = attitudeMatrixFromQuaternion(q)

A = transpose(XI(q)) * PSI(q);

end