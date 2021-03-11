classdef Orbit < handle
    %ORBIT Description of orbit
    %   
    
    properties
        parentBody;
        satellite;
        
        catalog;
        classification;
        launchYear;
        launchOfYear;
        pieceOfLaunch;
        epochYear;
        epochDay;
        meanMotionFirst;
        meanMotionSecond;
        bStar;
        ephemerisType;
        tleNum;
        inclination
        rightAscension;
        eccentricity;
        argumentOfPerigee;
        meanAnomaly;
        meanMotion;
        revAtEpoch;
        secPerOrbit;
    end
    properties (Access = private)
        ax = {}; % Axes handles where this is displayed
        L = {};  % Line handles
        S = {};  % Starting point handles
        an = {}; % Annotation structs
    end
    
    methods
        function obj = Orbit(tle, parent, sat)
            %ORBIT Construct an Orbit object
            %   Given a two-line element (TLE), will construct an orbit
            %   from that around a parent body (default Earth)
            
            obj.parentBody = parent;
            obj.satellite = sat;
            obj.parseTLE(tle);
        end
        
        function obj = fly(obj, N, optn, solver)
            if nargin < 4
                solver = @ode45;
                if nargin < 3
                    optn = odeset();
                    if nargin < 2
                        N = 10;
                    end
                end
            end
            optn.OutputFcn = @(t, y, flag) obj.satellite.stateUpdate(t,y, flag);
            optn.Stats = 'on';
            optn.MassSingular = 'no';
            IC = [obj.satellite.attitudeQuaternion; ...
                obj.satellite.angularVelocity];
            numFlatley = length(obj.satellite.hysteresisRod.Flatley);
            IC = [IC; zeros(numFlatley, 1)];
            solver(@(t, y) obj.satellite.equationOfMotion(t, y, obj), ...
                [0, N*obj.secPerOrbit] + obj.satellite.solnTime(end), ...
                IC, optn);
        end
        
        function [rx, ry, rz] = satellitePosition(obj, t, useAnomaly)
            if nargin < 3
                useAnomaly = false;
            end
            if useAnomaly
                TA = t;
            else
                TA = t/obj.secPerOrbit * 2 * pi;
            end

            rpd = obj.meanMotion;
            spd = 24 * 3600 / rpd; % Number of seconds for 1 orbit

            perigee = (1-obj.eccentricity) * (obj.parentBody.mu / (2*pi/spd)^2)^(1/3);

            TA = TA + obj.argumentOfPerigee;

            r   = [cos(TA); sin(TA); zeros(1,length(TA))] .* (perigee* (1 ...
                - (obj.eccentricity^2))./(1+obj.eccentricity * cos(TA)));
            r   = rotMatrix(obj.rightAscension, 3)*rotMatrix(obj.inclination, 1)*r;

            if nargout == 1
                rx = r;
            else
                rx  = r(1,:);
                ry  = r(2,:);
                rz  = r(3,:);
            end
        end
        
        function [ r, theta, phi ] = satellitePositionSpherical(obj, t, useAnomaly)
            if nargin < 3
                useAnomaly = false;
            end
            [rx, ry, rz] = obj.satellitePosition(t, useAnomaly);
            [theta, phi, r] = cart2sph(rx, ry, rz);
        end
        
        function obj = addToAxes(obj, ax, includeParent)
            if nargin < 3
                includeParent = true;
                if nargin < 2
                    f = figure;
                    ax = axes(f);
                end
            end
            obj.ax{end+1} = ax;
            hold(obj.ax{end}, 'on');
            rpd = obj.meanMotion;
            spd = 24 * 3600 / rpd; % Number of seconds for 1 orbit

            perigee = (1-obj.eccentricity) * (obj.parentBody.mu / (2*pi/spd)^2)^(1/3);

            t   = linspace(0, spd, 5e3);
            or  = t./spd * 2*pi + obj.argumentOfPerigee; % How far along orbit are we
            r   = [cos(or); sin(or); zeros(1,length(or))] .* (perigee* (1 ...
                - (obj.eccentricity^2))./(1+obj.eccentricity * cos(or)));
            r   = rotMatrix(obj.rightAscension, 3)*rotMatrix(obj.inclination, 1)*r;

            R = 1.5*(obj.parentBody.radius);
            
            if includeParent
                obj.parentBody.addToAxes(obj.ax{end});
                hold(obj.ax{end}, 'on');
            else
                view(obj.ax{end}, 140, 30); axis(obj.ax{end}, 'equal');
                obj.ax{end}.XLim = R*[-1 1]; 
                obj.ax{end}.YLim = R*[-1 1]; 
                obj.ax{end}.ZLim = R*[-1 1];
                xlabel(obj.ax{end},'$x$','interpreter','latex'); 
                ylabel(obj.ax{end},'$y$','interpreter','latex');
                zlabel(obj.ax{end},'$z$','interpreter','latex');
                obj.ax{end}.XTick = [];
                obj.ax{end}.YTick = [];
                obj.ax{end}.ZTick = [];
            end
            obj.L{end+1} = plot3(obj.ax{end}, r(1,:), r(2,:), r(3,:));
            obj.L{end}.LineWidth = 2;
            obj.S{end+1} = plot3(obj.ax{end}, r(1,1), r(2,1), r(3,1));
            obj.S{end}.MarkerSize = 30;
            obj.S{end}.Marker = '.';
            obj.an{end+1} = text(r(1,1), r(2,1), r(3,1), 'Periapsis','interpreter','latex',...
                'VerticalAlignment','bottom','HorizontalAlignment','right');
            hold(obj.ax{end}, 'off');
        end
    end
    methods (Access = private)
        function obj = parseTLE(obj,S)
            %PARSETLE Helper method to extract parameters from a TLE
            [m, n] = size(S);
            assert(m == 2 && n == 69 && ischar(S), ...
                strcat("The two-line orbital elements description", ...
                " must be a 2x69 array of characters"));
            % --- Line 1 ---
            check1 = 0;
            % Set catalog number and check lines [3 - 7]
            cat1 = str2double(S(1,3:7));
            cat2 = str2double(S(2,3:7));
            assert(cat1 == cat2, "Satellite catalog number mismatch.");
            obj.catalog = cat1;
            % Set classification [8]
            obj.classification = S(1,8);

            % Set international designators [10 - 17]
            Y = str2double(S(1, 10:11));
            if Y <= 56
                obj.launchYear = 2000 + Y;
            else
                obj.launchYear = 1900 + Y;
            end
            obj.launchOfYear = str2double(S(1,12:14));
            obj.pieceOfLaunch = S(1,15:17);

            % Set epoch [19 - 32]
            Y = str2double(S(1, 19:20));
            if Y <= 56
                obj.epochYear = 2000 + Y;
            else
                obj.epochYear = 1900 + Y;
            end
            obj.epochDay = str2double(S(1, 21:32));

            % Set first and second derivative of mean motion [34 - 52]
            obj.meanMotionFirst = str2double(S(1, 34:43));
            M = strsplit(S(1,45:52), '-');
            obj.meanMotionSecond = str2double(strcat(M{1}, 'e-', M{2}));

            % Set BSTAR [54 - 61]
            B = strsplit(S(1,54:61), '-');
            obj.bStar = str2double(strcat(B{1}, 'e-', B{2}));

            % Set ephemeris type (always zero [0]) [63]
            assert(str2double(S(1,63)) == 0, "Ephemeris type non-zero.");
            obj.ephemerisType = 0;

            % Element set number (a.k.a. TLE number) [65 - 68]
            obj.tleNum = str2double(S(1,65:68));

            % Check first checksum [69]
            for i = 1:68
                if strcmp(S(1,i), '-')
                    check1 = check1 + 1;
                elseif ~isnan(str2double(S(1,i)))
                    check1 = check1 + str2double(S(1,i));
                end
            end
            assert(mod(check1, 10) == str2double(S(1,69)), ...
                "Checksum error line 1");
            
            % --- Line 2 ---
            check2 = 0;
            % Set inclination [9 - 16]
            obj.inclination = str2double(S(2, 9:16));

            % Set right ascension of ascending node [18 - 25]
            obj.rightAscension = str2double(S(2, 18:25));

            % Set eccentricity [27 - 33]
            obj.eccentricity = str2double(strcat('0.', S(2, 27:33)));

            % Set argument of perigee [35 - 42]
            obj.argumentOfPerigee = str2double(S(2, 35:42));

            % Set mean anomaly [44 - 51]
            obj.meanAnomaly = str2double(S(2, 44:51));

            % Set mean motion (revolutions/day) [53 - 63]
            obj.meanMotion = str2double(S(2, 53:63));
            obj.secPerOrbit = 1/(obj.meanMotion * (1/24/3600));

            % Set revolution number at epoch [64 - 68]
            obj.revAtEpoch = str2double(S(2, 64:68));

            % Check second checksum [69]
            for i = 1:68
                if strcmp(S(2,i), '-')
                    check2 = check2 + 1;
                elseif ~isnan(str2double(S(2,i)))
                    check2 = check2 + str2double(S(2,i));
                end
            end
            assert(mod(check2, 10) == str2double(S(2,69)), "Checksum error line 2");
        end
    end
end

