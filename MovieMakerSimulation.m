clear
clc
warning off
%% window specs
addpath('./src');
set(0,'DefaultFigureWindowStyle','normal')
fig = figure('rend','painters','pos',[100 100 336 256]);

%% experiment specs
pnum = 300;
a = 1.435;
[xx,yy] = meshgrid(-40:0.25:40);

%% movie specs
data = load('../data/const_Coord.dat');
load('./ELS.mat');
frame = size(data,1)/pnum;
v = VideoWriter('../sim/const_els.avi');
v.FrameRate = 10;
open(v);

for f = 1:frame
    clf
    hold on
    
    %% image analysis
    CF = data((f-1)*pnum+1:f*pnum,:);
    CF_plot = [(1:pnum)',CF(:,[2,3])*a];
    [P_Type, GB, domain, Psi6, G_C6, ~, L_C6,theta] = ...
        IMAGE_ANALYSIS(CF);

    %% plot energy landscape
%     colormap(jet)
    colormap(flipud(gray(256)))
    policy = 'relax';
    switch policy
        case 'iso'
            contour(xx,yy,Ef{1},50);
            caxis([0 30])
        case 'relax'
            contour(xx,yy,Ef{1}*0.01,50);
            caxis([0 3])
        case 'NS'
            contour(xx,yy,fliplr(rot90(Ef{3},1)),75);
            caxis([0 30])
        case 'WE'
            contour(xx,yy,fliplr(Ef{3}),75);
            caxis([0 30])
    end
    
    %% plot particles
    plot(CF_plot(:,2),CF_plot(:,3),...
        'wo','markersize', 10, ...
        'MarkerFaceColor','w');
    for pt = 1:pnum
        if P_Type(pt) == -3 &&...
                G_C6>=0.8 &&...
                Psi6 <= 0.93
            plot(CF_plot(pt,2), CF_plot(pt,3),'o',...
                'markersize',10,...
                'MarkerFaceColor','y',...
                'MarkerEdgeColor','y');
        else
            sc = scatter(CF_plot(pt,2),CF_plot(pt,3),120,...
                'MarkerFaceColor',[Psi6,0,L_C6(pt)],...
                'MarkerEdgeColor','none',...
                'MarkerFaceAlpha',L_C6(pt));
        end
    end
    
    %% plot grain boundary
    if G_C6>=0.8 && Psi6 <= 0.93
        plot((-20:20)*cos(GB(1)*pi/180)+GB(2),...
            (-20:20)*sin(GB(1)*pi/180)+GB(3),...
            'w-','linewidth',2)
    end
    hold off
%     title(num2str(f));
    set(gca,'fontsize',16)
    axis([-35 35 -35 35])
    pbaspect([1 1 1])
    box on
    set(gca,'XTick',-40:20:40,'YTick',-40:20:40)
    drawnow
    this_frame = getframe(gcf);
    writeVideo(v,this_frame.cdata);
end
close(v)