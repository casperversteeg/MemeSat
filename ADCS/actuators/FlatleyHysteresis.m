classdef FlatleyHysteresis < HysteresisRodBase
    %FLATLEYHYSTERESIS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k = 2;
        q0 = 0;
    end
    
    methods
        function obj = FlatleyHysteresis(L, D, Hc, Br, Bs, h_hat, matl)
            if nargin < 7
                matl = string(missing);
            end
            obj.material = matl;
            obj.volume = L*1e-3 * pi/4 * (D*1e-3)^2;
            obj.Hc = Hc; obj.Br = Br; obj.Bs = Bs;
            obj.p = 1/Hc * tan(pi*Br/2/Bs);
            obj.h_hat = h_hat;
        end
        
        function [T, Bdot] = hysteresisTorque(obj, B)
            B_mag = (obj.h_hat)' * B;
            H_mag = B_mag / obj.mu0;
            obj.H_dot_old(end+1) = H_mag - obj.H_mag_old(end);
            obj.H_mag_old(end+1) = H_mag;
            outputArg = obj.Property1 + inputArg;
        end
    end
end

