classdef Satellite
    %SATELLITE Physical parameters and graphics methods
    %   A class structure that contains all the necessary elements to
    %   properly simulate the dynamic behavior of a satellite (i.e. moments
    %   of inertia, mass, dimensions, etc.). Also provides convenient
    %   methods for adding a satellite into a plot for visualization
    
    properties
        dim(1,3) = [0 0 0];
        mass(1,1) {mustBeNumeric}
        I(3,3) {mustBeNumeric}
        ang_vel(3,1) {mustBeNumeric} = [0; 0; 0];
        att_q(4,1) {mustBeNumeric} = [0; 0; 0; 1];
        att_A(3,3) {mustBeNumeric} = eye(3);
        perm_mag(3,1) {mustBeNumeric} = [0; 0; 0];
        vertices {mustBeNumeric}
        faces {mustBeInteger}
        
    end
    
    methods
        function obj = Satellite()
            %SATELLITE Constructs a 1U satellite
            %   Constructs an instance of Satellite as a 1U, 1kg cubesat,
            %   with the center of mass in the geometric center, and all
            %   mass evenly distributed. Has a permanent magnetic moment
            %   with strength ~5e-3 A m^2.
            
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
            obj.perm_mag = [-0.5; 0.5; 1.5] * 5e-3;
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
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

