classdef (Abstract) OblatenessBase < handle
    %OBLATENESSBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
    end
    
    properties (Hidden = true)    
        ax = {}; % Axes handles where this is displayed
        P = {};  % Patch handles
        Q = {};  % Quiver handles
        an = {}; % Annotation structs
    end
    
    methods (Abstract)
        obj = addToAxes(obj, ax)
    end
end

