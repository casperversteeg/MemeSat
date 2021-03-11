classdef Cubesat1U < SpacecraftBase
    %CUBESAT1U Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = Cubesat1U(name)
            %SATELLITE Constructs a 1U satellite
            %   Constructs an instance of Satellite as a 1U, 1kg cubesat,
            %   with the center of mass in the geometric center, and all
            %   mass evenly distributed. Has a permanent magnetic moment
            %   with strength ~5e-3 A m^2.
            
            obj.name = name;
            % Dimensions [x y z] [m]
            obj.dim = [0.1 0.1 0.1];
            % Mass [kg]
            obj.mass = 1;
            % Mass moment of inertia tensor [kg m^2]
            Ixx = obj.mass * (obj.dim(2)^2 + obj.dim(3)^2)/12;
            Iyy = obj.mass * (obj.dim(1)^2 + obj.dim(3)^2)/12;
            Izz = obj.mass * (obj.dim(1)^2 + obj.dim(2)^2)/12;
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
        end

    end
end

