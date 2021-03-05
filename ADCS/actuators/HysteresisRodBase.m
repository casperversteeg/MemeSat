classdef (Abstract) HysteresisRodBase < handle
    %HYSTERESISRODBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        material
        volume(1,1) {mustBeNumeric}
        Hc(1,1) {mustBeNumeric} % coercivity        [A/m]
        Br(1,1) {mustBeNumeric} % remanence         [T]
        Bs(1,1) {mustBeNumeric} % saturation        [T]
        p(1,1) {mustBeNumeric}  % stretching factor [-]
        h_hat(3,1) {mustBeNumeric} = [0; 0; 0]; % orientation
        
        H_mag_old = 0;
        H_dot_old = 0;
        B_hys_old = 0;
    end
    properties (Hidden = true)
        mu0 = 4e-7*pi; % Permeability of vacuum     [H/m]
    end
    
    methods (Abstract)
        Bhyst = inducedMagneticField(obj, B);
        m_hyst = inducedMagneticMoment(obj, B);
        [T, Bdot] = hysteresisTorque(obj, B);
    end
    
    methods
        function obj = plotHysteresisHistory(obj, ax)
            if nargin < 3
                f = figure;
                ax = axes(f);
            end
            hold(ax, 'on'); grid(ax, 'on'); 
            comet(ax, obj.H_mag_old, obj.B_hys_old);
            xlabel(ax, strcat('Magnetic Intensity, $H$', ...
                ' ($\mathrm{A\cdot m^{-1}}$)'),'interpreter','latex');
            ylabel(ax, strcat('Induced Magnetic Field, ', ...
                '$B_\mathrm{hyst}$ ($\mathrm{T}$)'), 'interpreter',...
                'latex');
            t = "Hysteresis history";
            if ~ismissing(obj.material)
                t = strcat(t, " for ", obj.material);
            end
            title(ax, t, 'interpreter','latex');
            ax.TickLabelInterpreter = 'latex';
            hold(ax,'off');
        end
    end
end

