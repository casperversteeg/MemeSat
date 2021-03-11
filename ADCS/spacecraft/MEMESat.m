classdef MEMESat < Cubesat1U
    %CUBESAT1U Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = MEMESat()
            obj@Cubesat1U('MEMESat-1');
            obj.hysteresisRod.other = ArctanHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod.other(end+1) = ArctanHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
            obj.hysteresisRod.other(end+1) = ArctanHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod.other(end+1) = ArctanHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
            obj.hysteresisRod.other(end+1) = ArctanHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod.other(end+1) = ArctanHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
        end
    end
end

