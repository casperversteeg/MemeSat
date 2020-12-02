function [ x, y, z ] = positionSph2Cart(r, theta, phi)

    x = r * cos(phi) * cos(theta);
    y = r * cos(phi) * sin(theta);
    z = r * sin(phi);
    
    if nargout == 1
        x = [x y z];
    end
    
end