classdef Earth < handle
    %EARTH Model of the Earth
    %   Earth is an object that allows us to have all environmental
    %   variables in one place. Not only does it provide a handy interface
    %   for creating graphics, but also initializes date models, ECEF and
    %   ECEI reference frames, magnetic field models, rarefied atmospheric
    %   drag models, and surface targets.
    
    properties
        gregorianDate;
        julianDate;
        
        radius = 6.3581e6; % [m]
        mu = 3.986004e14; % Standard gravitational parameter [m^3 s^-2]
        
        ECEF;
        ECEI;
        oblatenessModel;
        gravityModel;
        magneticField;
        atmosphericDrag;
    end
    properties (Access = private)
        ax = {}; % Axes handles where this is displayed
        P = {};  % Patch handles
        Q = {};  % Quiver handles
        an = {}; % Annotation structs
    end
    
    methods
        function obj = Earth(gregorianStartTime)
            %EARTH Construct an instance of this class
            %   Detailed explanation goes here
%             addpath('./oblateness','./magneticfield','./gravity','./drag');
            if nargin < 1
                gregorianStartTime = datetime();
            end
            obj.gregorianDate = datetime(gregorianStartTime);
            obj.julianDate = juliandate(obj.gregorianDate);
            obj.initialize('StandardECEF', 'StandardECEI', ...
                'sphericalOblateness', 'sphericalGravity', ...
                'dipoleMagneticField', 'constantDrag');
        end
        
        function obj = initialize(obj, varargin)
            i = 1;
            while i < numel(varargin)
                assert(ischar(varargin{i}), ...
                    "Earth object must be initialized with strings");
                switch(lower(varargin{i}))
                    case 'standardecef'
                        obj.ECEF = [];
                    case 'standardecei'
                        obj.ECEI = [];
                    case 'sphericaloblateness'
                        obj.oblatenessModel = SphericalOblateness(obj.radius);
                    case 'sphericalgravity'
                        obj.gravityModel = [];
                    case 'dipolemagneticfield'
                        obj.magneticField = DipoleMagneticField(obj.radius);
                    case 'constantdrag'
                        obj.atmosphericDrag = [];
                    otherwise
                        continue;
                end
                i = i + 1;
            end
        end
        
        function obj = addToAxes(obj,ax)
            if nargin < 2
                f = figure;
                ax = axes(f);
            end
            obj.oblatenessModel.addToAxes(ax);
        end
    end
end

