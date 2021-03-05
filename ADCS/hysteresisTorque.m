function [ Thyst ] = hysteresisTorque(B, B_prev, m_sat, param, A)

B_mag       = (param.h_hat)' * (A * B);
B_prev_mag  = (param.h_hat)' * (A * B_prev);

Bhyst       = (param.h_hat) * 2/pi * param.Bs * atan(param.p ...
    * (B_mag / param.mu0 + (-1)^(B_mag < B_prev_mag) * param.Hc));

Vhyst = 0.095*pi*(0.001^2)/4;
mu_hyst = Bhyst * Vhyst / param.mu0;

Thyst       = cross(mu_hyst, A*B);

end