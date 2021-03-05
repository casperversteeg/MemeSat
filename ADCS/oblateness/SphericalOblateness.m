classdef SphericalOblateness < OblatenessBase
    %SPHERICALOBLATENESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xs;
        ys;
        zs;
    end
    
    methods
        function obj = SphericalOblateness(R)
            %SPHERICALOBLATENESS Construct an instance of this class
            %   Detailed explanation goes here
            [x, y, z] = sphere;
            obj.radius = R;
            obj.xs = R*x;
            obj.ys = R*y;
            obj.zs = R*z;
        end
        
        function obj = addToAxes(obj, ax)
            if nargin < 2
                f = figure;
                ax = axes(f);
            end
            obj.ax{end+1} = ax;
            hold(obj.ax{end}, 'on');
            obj.P{end+1} = patch(obj.ax{end}, surf2patch(obj.xs, obj.ys,...
                obj.zs));
            obj.P{end}.FaceColor = 'cyan';
            obj.P{end}.EdgeAlpha = 0.5;
            obj.P{end}.FaceAlpha = 0.5;
            obj.P{end}.Annotation.LegendInformation.IconDisplayStyle = 'off';
            R = 1.5*obj.radius;
            obj.Q{end+1} = struct(...
                'Q1', quiver3(obj.ax{end}, 0, 0, 0, R, 0, 0, 0),...
                'Q2', quiver3(obj.ax{end}, 0, 0, 0, 0, R, 0, 0),...
                'Q3', quiver3(obj.ax{end}, 0, 0, 0, 0, 0, R, 0));
            fnames = fieldnames(obj.Q{end}); 
            vColor = ["red","blue","green"];
            for i = 1:numel(fnames)
                obj.Q{end}.(fnames{i}).LineWidth = 2;
                obj.Q{end}.(fnames{i}).MaxHeadSize = 0.3;
                obj.Q{end}.(fnames{i}).Color = vColor(i);
            end
            view(obj.ax{end}, 140, 30); axis(obj.ax{end}, 'equal');
            xlabel(obj.ax{end},'$x$','interpreter','latex'); 
            ylabel(obj.ax{end},'$y$','interpreter','latex');
            zlabel(obj.ax{end},'$z$','interpreter','latex');
            obj.ax{end}.TickLabelInterpreter = 'latex';
            obj.ax{end}.XLim = R*[-1 1]; 
            obj.ax{end}.YLim = R*[-1 1]; 
            obj.ax{end}.ZLim = R*[-1 1];
            obj.ax{end}.XTick = [];
            obj.ax{end}.YTick = [];
            obj.ax{end}.ZTick = [];
            obj.an{end+1} = struct(...
                'an_x', text(R, 0, 0, '$\Upsilon$', 'interpreter',...
                        'latex', 'VerticalAlignment','bottom',...
                        'HorizontalAlignment','right'),...
                'an_y', text(0, R, 0, '$y$','interpreter','latex'),...
                'an_z', text(0, 0, R, '$z$','interpreter','latex',...
                        'VerticalAlignment', 'bottom'));
            hold(obj.ax{end}, 'off');
        end
    end
end

