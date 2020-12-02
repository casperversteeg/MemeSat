function [ E ] = sphericalEarth(R)

[xs,ys,zs] = sphere;
xs = R*xs;
ys = R*ys;
zs = R*zs;

f = figure;
ax = axes(f);
P1 = patch(ax, surf2patch(xs,ys,zs));
E = copy(P1);
E.FaceColor = 'cyan';
E.FaceAlpha = 0.5;
E.EdgeAlpha = 0.5;
E.Annotation.LegendInformation.IconDisplayStyle = 'off';
close(f);

end