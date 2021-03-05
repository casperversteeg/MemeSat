classdef DipoleMagneticField < MagneticFieldBase
    %DIPOLEMAGNETICFIELD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        B0(1,1) {mustBeNumeric} = 3.12e-5; % Mean |B| at r = Re [T]
    end
    
    methods
        function obj = DipoleMagneticField(R)
            obj.radius = R;
        end
        
        function Br = Br(obj, r, ~, phi) 
            Br = -2 * obj.B0 * (obj.radius ./ r).^3 .* sin(phi);
        end
        function Btheta = Btheta(~, ~, ~, ~)
            Btheta = 0;
        end
        function Bphi = Bphi(obj, r, ~, phi)
            Bphi = obj.B0 * (obj.radius ./ r).^3 .* cos(phi);
        end
        function Bsph = Bsph(obj, r, theta, phi)
            Bsph = [obj.Br(r,theta, phi); 
                    obj.Btheta(r, theta, phi);...
                    obj.Bphi(r, theta, phi)];
        end
        function Bx = Bx(obj, r, theta, phi)
            Bx = cos(phi).*cos(theta).*obj.Br(r, theta, phi)...
                - sin(theta).*obj.Btheta(r, theta, phi)...
                - sin(phi).*cos(theta).*obj.Bphi(r,theta,phi);
        end
        function By = By(obj, r, theta, phi)
            By = cos(phi).*sin(theta).*obj.Br(r, theta, phi)...
                + cos(theta).*obj.Btheta(r, theta, phi)...
                - sin(phi).*sin(theta).*obj.Bphi(r,theta,phi);
        end
        function Bz = Bz(obj, r, theta, phi)
            Bz = sin(phi).*obj.Br(r, theta, phi) ...
                + cos(phi).*obj.Bphi(r, theta, phi);
        end
        function [Bx, By, Bz] = Bcart(obj, r, theta, phi)
            Bcart = [obj.Bx(r, theta, phi);
                     obj.By(r, theta, phi);
                     obj.Bz(r, theta, phi)];
            if nargout == 1
                Bx = Bcart;
            else
                Bx = Bcart(1,:);
                By = Bcart(2,:);
                Bz = Bcart(3,:);
            end
        end
        
        function obj = addToAxes(obj, r, ax, nTheta, nPhi)
            if nargin < 5
                nPhi = 20;
                if nargin < 4
                    nTheta = 20;
                    if nargin < 3
                        f = figure; 
                        ax = axes(f);
                    end
                end
            end
            th = linspace(0, 2*pi, nTheta +1);
            th = th(1:end-1);
            ph = linspace(-pi/2, pi/2, nPhi);
            X = zeros(1, nTheta*nPhi); Y = X; Z = X;
            for i = 1:nTheta
                for j = 1:nPhi
                    In = (i-1)*nTheta + j;
                    [X(In), Y(In), Z(In)] = positionSph2Cart(r, th(i), ph(j));
                    [Bx(In), By(In), Bz(In)] = obj.Bcart(r, th(i), ph(j));
                end
            end
            hold(ax, 'on');
            Q = quiver3(ax, X, Y, Z, Bx, By, Bz);
            Q.MaxHeadSize = 0.5;
            hold(ax, 'off');
        end
    end
end

