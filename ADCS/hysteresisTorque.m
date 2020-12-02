function [ Thyst ] = hysteresisTorque(B, B_prev, m_sat, param)

B_mag       = param.h_hat' * B;
B_prev_mag  = param.h_hat' * B_prev;

Bhyst       = param.h_hat * 2/pi * param.Bs * atan(param.p ...
    * (B_mag / param.mu0 + (-1)^(B_mag > B_prev_mag) * param.Hc));

Thyst       = cross(m_sat, Bhyst);

end