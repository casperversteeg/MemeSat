function [ OMEGA ] = OMEGA(w)

OMEGA = [ -crossMatrix(w), w;
          transpose(w), 0];
      
end