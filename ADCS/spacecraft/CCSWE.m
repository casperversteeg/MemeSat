classdef CCSWE < Cubesat3U
    %CUBESAT1U Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = CCSWE()
            obj@Cubesat3U('CCSWE');
            obj.hysteresisRod.Flatley = FlatleyHysteresis(95, 1, ...
                0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod.Flatley(end+1) = FlatleyHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
            obj.hysteresisRod.Flatley(end+1) = FlatleyHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod.Flatley(end+1) = FlatleyHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
            obj.hysteresisRod.Flatley(end+1) = FlatleyHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod.Flatley(end+1) = FlatleyHysteresis(95, 1,...
                0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
        end
    end
end

