classdef (Abstract) HysteresisRodBase < handle
    %HYSTERESISRODBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        material
        volume(1,1) {mustBeNumeric}
        Hc(1,1) {mustBeNumeric} % coercivity        [A/m]
        Br(1,1) {mustBeNumeric} % remanence         [T]
        Bs(1,1) {mustBeNumeric} % saturation        [T]
        k(1,1) {mustBeNumeric}  % stretching factor [-]
        h_hat(3,1) {mustBeNumeric} = [0; 0; 0]; % orientation
        
        solnHloc = 0;
        solnHdotloc = 0;
        solnBindrod = 0;
    end
    properties (Hidden = true)
        mu0 = 4e-7*pi; % Permeability of vacuum     [H/m]
    end
    
    methods (Abstract)
        Bhyst = inducedMagneticField(obj, B);
        P = plotHysteresisLoop(obj, Hlim, ax);
    end
    
    methods
        function m_hyst = inducedMagneticMoment(obj)
            %inducedMagneticMoment Magnetic moment of the hysteresis rod 
            % due to externally applied magnetic field
            %   Computes the induced magnetic moment in the hysteresis rod,
            %   due to an applied magnetic field, B, by scaling the induced
            %   magnetic field by the rod's volume, and using the result of
            %   that to scale the orientation vector.
            m_hyst = obj.solnBindrod(end) * obj.volume / obj.mu0 * obj.h_hat;
        end
        
        function T = hysteresisTorque(obj, Bloc)
            T = cross(obj.inducedMagneticMoment, Bloc);
        end
        
        function obj = HysteresisRodBase(L, D, Hc, Br, Bs, h_hat, matl)
            %HYSTERESISROD Constructs a hysteresis rod
            %   Constructs an instance of a hysteresis rod. The material
            %   name tag 'matl' is for user reference only. The geometric
            %   parameters 'L' and 'D' specify the length, and diameter of
            %   a cylindrical rod, respectively (in millimeters). 
            %
            %   The material properties required to define a hysteresis
            %   loop are the coercive force, Hc, the remanence, Br, and the
            %   saturation induction, Bs. The coercive force should be
            %   given in units of A/m, whereas Br and Bs should be given in
            %   units of Tesla.
            if nargin < 7
                matl = string(missing);
            end
            obj.material = matl;
            obj.volume = L*1e-3 * pi/4 * (D*1e-3)^2;
            obj.Hc = Hc; obj.Br = Br; obj.Bs = Bs;
            obj.k = 1/Hc * tan(pi*Br/2/Bs);
            obj.h_hat = h_hat;
        end
        
        function obj = plotHysteresisHistory(obj, ax)
            if nargin < 3
                f = figure;
                ax = axes(f);
            end
            hold(ax, 'on'); grid(ax, 'on'); 
            comet(ax, obj.solnHloc, obj.solnBindrod);
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

