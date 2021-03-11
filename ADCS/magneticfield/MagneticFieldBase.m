classdef (Abstract) MagneticFieldBase < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius
        mu0 = 4e-7 * pi;
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
    
    methods
        function Hr = Hr(obj, r, theta, phi)
            Hr = obj.Br(r, theta, phi) / obj.mu0;
        end
        
        function Htheta = Htheta(obj, r, theta, phi)
            Htheta = obj.Btheta(r, theta, phi) / obj.mu0;
        end
        
        function Hphi = Hphi(obj, r, theta, phi)
            Hphi = obj.Bphi(r, theta, phi) / obj.mu0;
        end
        
        function Hsph = Hsph(obj, r, theta, phi)
            Hsph = obj.Bsph(r, theta, phi) / obj.mu0;
        end
        
        function Hx = Hx(obj, r, theta, phi)
            Hx = obj.Bx(r, theta, phi) / obj.mu0;
        end
        
        function Hy = Hy(obj, r, theta, phi)
            Hy = obj.By(r, theta, phi) / obj.mu0;
        end
        
        function Hz = Hz(obj, r, theta, phi)
            Hz = obj.Bz(r, theta, phi) / obj.mu0;
        end
        
        function Hcart = Hcart(obj, r, theta, phi)
            Hcart = obj.Bcart(r, theta, phi) / obj.mu0;
        end
    end
end

