classdef FlatleyHysteresis < HysteresisRodBase
    %FLATLEYHYSTERESIS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        p = 2;
        q0 = 0;
        
        tempHloc = 0;
        tempHdotloc = 0;
        tempTime = 0;
        
        solnTime(1,:) = 0;
    end
    
    methods
        function obj = FlatleyHysteresis(L, D, Hc, Br, Bs, h_hat, matl)
            obj@HysteresisRodBase(L, D, Hc, Br, Bs, h_hat, matl);
        end
        
        function [Bdotindrod] = inducedMagneticField(obj, t, B, H)
            if t == 0
                Bdotindrod = 0;
                return;
            end
            obj.tempHloc(end+1) = obj.h_hat' * H;
            obj.tempHdotloc(end+1) = (obj.tempHloc(end)-obj.tempHloc(end-1))/(t - obj.tempTime(end));
            obj.tempTime(end+1) = t;
%             if obj.tempHdotloc(end) > 0
%                 B = min([B, ...
%                     obj.B_lim(obj.tempHloc(end), obj.tempHdotloc(end))]);
%             else
%                 B = max([B, ...
%                     obj.B_lim(obj.tempHloc(end), obj.tempHdotloc(end))]);
%             end
            Bdotindrod = obj.dBdH(B, obj.tempHloc(end), obj.tempHdotloc(end)) * obj.tempHdotloc(end);
        end
        
        function P = plotHysteresisLoop(obj, Hlim, ax)
            if nargin < 3
                f = figure;
                ax = axes(f);
            end
            obj.clear();
            hold(ax, 'on'); grid(ax, 'on'); 
            H = @(t) Hlim.* sin(2*pi.*t);
%             dH = @(t) 2*pi* Hlim.* cos(2*pi*t);
            H_vec = @(t) obj.h_hat * H(t);
            optn = odeset('MaxStep', 1e-3);
            optn.OutputFcn = @(t, y, flag) obj.stateUpdate(t,y, flag);
            optn.Stats = 'on';
%             optn.MassSingular = 'no';
            [tsoln, Bsoln] = ode23(...
                @(t, B) obj.inducedMagneticField(t, B, H_vec(t)), [0 1], 0, optn);
            yyaxis(ax, 'left');
            P = plot(ax, H(tsoln), Bsoln);
            for i = 1:length(tsoln)
                P.XData = H(tsoln(1:i));
                P.YData = Bsoln(1:i);
                drawnow;
            end
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
%             obj.clear();
        end
        
        function status = stateUpdate(obj, t, y, flag)
            if isempty(flag) || nargin < 4
                [~, n] = size(y);
                obj.solnTime(end+1:end+n) = t;
                obj.solnHloc(end+1:end+n) = obj.tempHloc(end-n+1:end);
                obj.solnHdotloc(end+1:end+n) = obj.tempHdotloc(end-n+1:end);
%                 for i = 1:n
%                     if obj.tempHdotloc(end-n+i) > 0
%                         obj.solnBindrod(end+1) = min([y(i), ...
%                             obj.B_lim(obj.tempHloc(end-n+i), obj.tempHdotloc(end-n+i))]);
%                     else
%                         obj.solnBindrod(end+1) = max([y(i), ...
%                             obj.B_lim(obj.tempHloc(end-n+i), obj.tempHdotloc(end-n+i))]);
%                     end
%                 end
                obj.solnBindrod(end+1:end+n) = y;
            end
            obj.tempHloc = obj.tempHloc(end);
            obj.tempHdotloc = obj.tempHdotloc(end);
            obj.tempTime = t;
            status = 0;
        end
    end
    
    methods (Access = private)
        function BL = B_lim(obj, H, Hdot)
            BL = obj.Bs * 2 / pi * atan(obj.k*(H - (-1)^(Hdot < 0) * obj.Hc));
        end
        
        function HL = H_lim(obj, B, Hdot) 
            HL = 1/obj.k * tan(pi/2 * B/obj.Bs) - (-1)^(Hdot < 0) * obj.Hc;
        end
        
        function dBdH = dBdH(obj, B, H, Hdot) 
            dBdH = obj.q0 + (1-obj.q0) * ((H - obj.H_lim(B, Hdot))/2/obj.Hc).^obj.p;
            dBdH = 2/pi * obj.k * obj.Bs * cos(pi/2*B/obj.Bs)^2 * dBdH;
        end
        
        function clear(obj)
            obj.solnTime = 0;
            obj.solnHloc = 0;
            obj.solnHdotloc = 0;
            obj.solnBindrod = 0;
        end
    end
end

