classdef ArctanHysteresis < HysteresisRodBase
    %HYSTERESISROD Hysteresis rod object
    %   Hysteresis rods are magnetizeable materials that dissipate energy
    %   as their polarity changes
    
    methods
        function obj = ArctanHysteresis(L, D, Hc, Br, Bs, h_hat, matl)
            obj@HysteresisRodBase(L, D, Hc, Br, Bs, h_hat, matl);
        end
        
        function Bhyst = inducedMagneticField(obj, Bloc, tRange)
            obj.solnBloc(end+1) = (obj.h_hat)' * Bloc;
            obj.solnBlocdot(end+1) = (obj.solnBloc(end) - obj.solnBloc(end-1))/(tRange(2)-tRange(1));
            obj.solnHmag(end+1) = H_mag;
            Bhyst = 2/pi * obj.Bs * atan(obj.k...
                *(obj.solnBloc(end)/obj.mu0 ...
                + (-1).^(obj.Bdotloc(end) > 0) .* obj.Hc));
            obj.solnBindrod(end+1) = Bhyst;
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
            Bhyst1 = 2/pi * obj.Bs * atan(obj.k*(x1 - obj.Hc));
            Bhyst2 = 2/pi * obj.Bs * atan(obj.k*(x1 + obj.Hc));
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

