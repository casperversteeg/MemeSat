classdef HysteresisRod < handle
    %HYSTERESISROD Hysteresis rod object
    %   Hysteresis rods are magnetizeable materials that dissipate energy
    %   as their polarity changes
    
    properties
        material
        volume(1,1) {mustBeNumeric}
        Hc(1,1) {mustBeNumeric} % coercivity        [A/m]
        Br(1,1) {mustBeNumeric} % remanence         [T]
        Bs(1,1) {mustBeNumeric} % saturation        [T]
        p(1,1) {mustBeNumeric}  % stretching factor [-]
        h_hat(3,1) {mustBeNumeric} = [0; 0; 0]; % orientation
        
        H_mag_old = 0;
    end
    properties (Access = private)
        mu0 = 4e-7*pi; % Permeability of vacuum     [H/m]
    end
    
    methods
        function obj = HysteresisRod(L, D, Hc, Br, Bs, h_hat, matl)
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
            obj.p = 1/Hc * tan(pi*Br/2/Bs);
            obj.h_hat = h_hat;
        end
        
        function Bhyst = inducedMagneticField(obj, B, Bdot)
            %inducedMagneticField Magnetization of the hysteresis rod by
            % externally applied magnetic field
            %   Computes the induced magnetic field in the hysteresis rod,
            %   due to an applied magnetic field, B. Since hysteresis is a
            %   delayed effect, this also depends on the rate of change of
            %   the magnetic field, Bdot.
            if nargin < 3
                Bdot = - obj.mu0*obj.H_mag_old(end);
            end
            [m, ~] = size(B);
            if m == 1
                B_mag = B;
            else
                assert(m == 3, ...
                    "External magnetic field must be a 3x1 vector");
                B_mag = (obj.h_hat)' * B;
            end
            if nargin < 3
                Bdot = B_mag + Bdot;
            end
            H_mag = B_mag / obj.mu0;
%             obj.H_mag_old(end+1) = H_mag;
            Bhyst = 2/pi * obj.Bs * atan(obj.p...
                *(H_mag + (-1).^(Bdot > 0) .* obj.Hc));
        end
        
        function m_hyst = inducedMagneticMoment(obj, B, Bdot)
            %inducedMagneticMoment Magnetic moment of the hysteresis rod 
            % due to externally applied magnetic field
            %   Computes the induced magnetic moment in the hysteresis rod,
            %   due to an applied magnetic field, B, by scaling the induced
            %   magnetic field by the rod's volume, and using the result of
            %   that to scale the orientation vector.
            if nargin < 3
                m_hyst = obj.inducedMagneticField(B) ...
                    * obj.volume / obj.mu0 * obj.h_hat;
            else
                m_hyst = obj.inducedMagneticField(B, Bdot) ...
                    * obj.volume / obj.mu0 * obj.h_hat;
            end
%             if nargin < 3
%                 Bdot = - obj.mu0*obj.H_mag_old(end);
%             end
%             [m, ~] = size(B);
%             if m == 1
%                 B_mag = B;
%             else
%                 assert(m == 3, ...
%                     "External magnetic field must be a 3x1 vector");
%                 B_mag = (obj.h_hat)' * B;
%             end
%             if nargin < 3
%                 Bdot = B_mag + Bdot;
%             end
%             m_hyst = obj.inducedMagneticField(B, Bdot) ...
%                 * obj.volume / obj.mu0 * obj.h_hat;
        end
        
        function P = plotHysteresisLoop(obj, Hlim, ax)
            %plotHysteresisLoop Plots the hysteresis loop
            %   Given a range of magnetic field intensity, Hlim, this will
            %   plot the hysteresis loop corresponding to this rod.
            %   Optionally, a second argument containing and axes handle
            %   may be provided, in which case the plot will be displayed
            %   in those axes.
            if nargin < 3
                f = figure;
                ax = axes(f);
            end
            hold(ax, 'on'); grid(ax, 'on'); 
            x1 = linspace(-Hlim, Hlim, 100) * obj.mu0;
            x2 = fliplr(x1);
            x = [x1, x2, x1(1)];
            Bhyst1 = obj.inducedMagneticField(x1, 1);
            Bhyst2 = obj.inducedMagneticField(x2, -1);
            Bhyst = [Bhyst1, Bhyst2, Bhyst1(1)];
            x = x / obj.mu0;
            yyaxis(ax, 'left');
            P = plot(ax, x, Bhyst);
            xlabel(ax, strcat('Magnetic Intensity, $H$', ...
                ' ($\mathrm{A\cdot m^{-1}}$)'),'interpreter','latex');
            ylabel(ax, strcat('Induced Magnetic Field, ', ...
                '$B_\mathrm{hyst}$ ($\mathrm{T}$)'), 'interpreter',...
                'latex');
            t = "Hysteresis loop";
            if ~ismissing(obj.material)
                t = strcat(t, " for ", obj.material);
            end
            title(ax, t, 'interpreter','latex');
            ax.TickLabelInterpreter = 'latex';
            ax.YColor = 'k';
            yyaxis(ax, 'right');
            ax.YColor = 'k';
            ax.YAxis(1).TickLabelFormat = '%g';
            ax.YAxis(2).Limits = ax.YAxis(1).Limits * obj.volume / obj.mu0;
            ax.YAxis(2).TickValues = ax.YAxis(1).TickValues *...
                obj.volume / obj.mu0;
            ylabel(ax, strcat('Induced Magnetic Moment, ',...
                '$\mathbf{m}_\mathrm{hyst}$ ($\mathrm{A\cdot m^2}$)'),...
                'interpreter','latex');
            ax.YAxis(2).TickLabelFormat = '%g';
            hold(ax,'off');
        end
    end
end

