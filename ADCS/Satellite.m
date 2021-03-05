classdef Satellite < handle
    %SATELLITE Physical parameters and graphics methods
    %   A class structure that contains all the necessary elements to
    %   properly simulate the dynamic behavior of a satellite (i.e. moments
    %   of inertia, mass, dimensions, etc.). Also provides convenient
    %   methods for adding a satellite into a plot for visualization
    
    properties
        name = "";
        dim(1,3) = [0 0 0];
        mass(1,1) {mustBeNumeric}
        I(3,3) {mustBeNumeric}
        angularVelocity(3,1) {mustBeNumeric} = [0; 0; 0];
        solnAngularVelocity(3,:) {mustBeNumeric} = [0; 0; 0];
        attitudeQuaternion(4,1) {mustBeNumeric} = [0; 0; 0; 1];
        solnAttitudeQuaternion(4,:) {mustBeNumeric} = [0; 0; 0; 1];
        permanentMagnet(3,1) {mustBeNumeric} = [0; 0; 0];
        vertices {mustBeNumeric}
        faces {mustBeInteger}
        
        hysteresisRod = [];
        
        solnTime(1,:) {mustBeNumeric} = 0;
    end
    properties (Access = private)
        tRange(1,2) {mustBeNumeric} = [0 0];
        
        pcntFlag = zeros(1,100);
        
        ax = {}; % Axes handles where this is displayed
        P = {};  % Patch handles
        Q = {};  % Quiver structs
        an = {}; % Annotation structs
    end
    
    methods
        function obj = Satellite(name)
            %SATELLITE Constructs a 1U satellite
            %   Constructs an instance of Satellite as a 1U, 1kg cubesat,
            %   with the center of mass in the geometric center, and all
            %   mass evenly distributed. Has a permanent magnetic moment
            %   with strength ~5e-3 A m^2.
            
            obj.name = name;
            % Dimensions [x y z] [m]
            obj.dim = [0.1 0.1 0.3];
            % Mass [kg]
            obj.mass = 1;
            % Mass moment of inertia tensor [kg m^2]
%             Ixx = obj.mass * (obj.dim(2)^2 + obj.dim(3)^2)/12;
%             Iyy = obj.mass * (obj.dim(1)^2 + obj.dim(3)^2)/12;
%             Izz = obj.mass * (obj.dim(1)^2 + obj.dim(2)^2)/12;
            Ixx = 2.22e-2; Iyy = 2.18e-2; Izz = 5e-3;
            obj.I = diag([Ixx Iyy Izz]); 
            % Permanent magnetic dipole moment A m^2
            obj.permanentMagnet = [0; 0; 1] * 0.55;
            % Satellite vertices [x y z] [m]
            V   = [1  1  1; -1  1  1; -1 -1  1; 1 -1  1; ...
                   1  1 -1; -1  1 -1; -1 -1 -1; 1 -1 -1];
            V(:,1) = V(:,1) * obj.dim(1)/2;
            V(:,2) = V(:,2) * obj.dim(2)/2;
            V(:,3) = V(:,3) * obj.dim(3)/2;
            obj.vertices = V;
            % Connectivity array for faces [v1 v2 v3 v4]
            obj.faces = [1 2 3 4; 1 4 8 5; 5 6 7 8; ...
                         2 3 7 6; 1 2 6 5; 3 4 8 7];
            obj.hysteresisRod = ArctanHysteresis(95, 1, 0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod(end+1) = ArctanHysteresis(95, 1, 0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
            obj.hysteresisRod(end+1) = ArctanHysteresis(95, 1, 0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod(end+1) = ArctanHysteresis(95, 1, 0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
            obj.hysteresisRod(end+1) = ArctanHysteresis(95, 1, 0.3381, 6.0618e-4, 0.3, [0;1;0], "HyMu-80");
            obj.hysteresisRod(end+1) = ArctanHysteresis(95, 1, 0.3381, 6.0618e-4, 0.3, [1;0;0], "HyMu-80");
        end
        
        function Y = equationOfMotion(obj, t, ~, orbit)
            [rh, th, ph] = orbit.satellitePositionSpherical(t);
            B_inertial = orbit.parentBody.magneticField.Bcart(rh, th, ph);
            B_body = obj.attitudeMatrix * B_inertial;
            [~, n] = size(obj.permanentMagnet);
            T = [0;0;0];
            for i = 1:n
                T = T + cross(obj.permanentMagnet(:,i), B_body);
            end
            for i = 1:numel(obj.hysteresisRod)
                T = T + cross(obj.hysteresisRod(i).inducedMagneticMoment(B_body), B_body);
            end
            qdot = 0.5 * OMEGA(obj.angularVelocity) * obj.attitudeQuaternion;
            wdot = -obj.I \ crossMatrix(obj.angularVelocity) * obj.I * obj.angularVelocity + obj.I \ T;
            Y = [qdot; wdot]; 
        end
        
        function status = stateUpdate(obj, t, y, flag)
%             fprintf("%f\n", t);
            switch (flag)
                case 'init'
                    obj.tRange = [t(1) t(end)];
                    fprintf('%s -- ', datetime());
                    fprintf("State initialized\n");
                case 'done'
                    fprintf("Simulation finished\n"); 
                    obj.pcntFlag = 0*obj.pcntFlag;
            end
            if ~isempty(y)
%                 y(1:4, :) = y(1:4, :)./vecnorm(y(1:4,:));
                odeplot(t/3600, y(5:7,:)*180/pi, flag);
            end
            if isempty(flag) || nargin < 4
                [~, n] = size(y);
                q = y(1:4,:)./vecnorm(y(1:4,:));
                obj.solnTime(end+1:end+n) = t;
                obj.solnAttitudeQuaternion(:, end+1:end+n) = q;
                obj.attitudeQuaternion = q(:,end);
                obj.solnAngularVelocity(:,end+1:end+n) = y(5:7, :);
                obj.angularVelocity = y(5:7, end);
                obj.updateProgress(t);
            end
            status = 0;
        end
        
        function obj = updateProgress(obj, t)
            tSpan = obj.tRange(2) - obj.tRange(1);
            for i = 1:100
                if t(end) - obj.tRange(1) > i/100 * tSpan && ~obj.pcntFlag(i)
                    fprintf("%s -- %d%% done\n", datetime(), i);
                    obj.pcntFlag(1:i) = 1;
                    continue;
                end
            end
        end
        
        function obj = initializeAngularVelocity(obj, w)
            obj.solnAngularVelocity = w;
            obj.angularVelocity = w;
        end
        
        function obj = initializeAttitudeByQ(obj, q)
            obj.solnAttitudeQuaternion = q;
            obj.attitudeQuaternion = q;
        end
        
        function obj = initializeAttitudeByMatrix(obj, A)
            q = zeros(4,1);
            q(4) = 0.5*sqrt(1+trace(A));
            for i = 1:3
                q(i) = sqrt((1-trace(A) + 2*A(i,i))/4);
            end
            obj.solnAttitudeQuaternion = q;
            obj.attitudeQuaternion = q;
        end
        
%         function obj = initializeAttitudeByPRY(obj, p, r, y, seq)
%             switch (seq)
%                 
%             end
%             obj.oldAttitudeQuaternion = q;
%             obj.attitudeQuaternion = q;
%         end
        
        function obj = addToAxes(obj,axs)
            %addToAxes Keep track of axes handles where sat is displayed
            %   Adds this satellite object to axes 'ax', which allows us to
            %   keep track of where we need to update the visualization of
            %   this satellite.
            if nargin < 2
                f = figure;
                axs = axes(f);
            end
            obj.ax{end+1} = axs;
            hold(obj.ax{end}, 'on');
            obj.P{end+1} = patch(obj.ax{end}, 'Faces', obj.faces, ...
                'Vertices', obj.vertices);
            obj.P{end}.EdgeColor = 'black';
            obj.P{end}.FaceColor = [1 1 1] * 0.9;
            obj.P{end}.FaceAlpha = 0.3;
            w_max = max(obj.dim/2);
            q_max = 1.5*w_max;
            obj.Q{end+1} = struct(...
                'Q1', quiver3(obj.ax{end}, 0, 0, 0, q_max, 0, 0, 0),...
                'Q2', quiver3(obj.ax{end}, 0, 0, 0, 0, q_max, 0, 0),...
                'Q3', quiver3(obj.ax{end}, 0, 0, 0, 0, 0, q_max, 0));
            fnames = fieldnames(obj.Q{end}); 
            vColor = ["red","blue","green"];
            for i = 1:numel(fnames)
                obj.Q{end}.(fnames{i}).LineWidth = 2;
                obj.Q{end}.(fnames{i}).MaxHeadSize = 0.3;
                obj.Q{end}.(fnames{i}).Color = vColor(i);
            end
            view(obj.ax{end}, 130, 30); axis(obj.ax{end}, 'equal');
            xlabel(obj.ax{end},'$x$','interpreter','latex'); 
            ylabel(obj.ax{end},'$y$','interpreter','latex');
            zlabel(obj.ax{end},'$z$','interpreter','latex');
            title(obj.ax{end}, obj.name,'interpreter','latex');
            obj.ax{end}.TickLabelInterpreter = 'latex';
            obj.ax{end}.XLim = sqrt(3)*w_max*[-1 1]; 
            obj.ax{end}.YLim = sqrt(3)*w_max*[-1 1]; 
            obj.ax{end}.ZLim = sqrt(3)*w_max*[-1 1];
            obj.an{end+1} = struct(...
                'an_x', text(q_max, 0, 0, '$x$','interpreter','latex',...
                        'VerticalAlignment','bottom',...
                        'HorizontalAlignment','right'),...
                'an_y', text(0, q_max, 0, '$y$','interpreter','latex'),...
                'an_z', text(0, 0, q_max, '$z$','interpreter','latex',...
                        'VerticalAlignment', 'bottom'));
            hold(obj.ax{end}, 'off');
        end
        
        function A = attitudeMatrix(obj)
            %attitudeMatrix Gives the current rotation matrix
            %   Will compute the rotation matrix, A, that transforms a 
            %   vector in the inertial frame, n, to a vector represented 
            %   in the body frame, b, i.e. b = A*n.
            A = attitudeMatrixFromQuaternion(obj.attitudeQuaternion);
        end
    end
end

