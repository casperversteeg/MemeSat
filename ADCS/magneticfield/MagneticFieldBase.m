classdef (Abstract) MagneticFieldBase < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius
    end
    
    methods (Abstract)
        Br = Br(obj, r, theta, phi);
        Btheta = Btheta(obj, r, theta, phi);
        Bphi = Bphi(obj, r, theta, phi);
        Bsph = Bsph(obj, r, theta, phi);
        Bx = Bx(obj, r, theta, phi);
        By = By(obj, r, theta, phi);
        Bz = Bz(obj, r, theta, phi);
        Bcart = Bcart(r, theta, phi);
        
        obj = addToAxes(obj, ax);
    end
end

