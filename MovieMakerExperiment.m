clear
clc
warning off
%% window specs
addpath('./src');
set(0,'DefaultFigureWindowStyle','normal')
fig = figure('rend','painters','pos',[100 100 336 256]);

%% experiment specs
a = 1.435;
scale = 1214*(4/8)*(40/63)*(1/1)/1000;
psi6Scale = 0.88;
C6Scale = .9;

%% movie specs
data = VideoReader('../data/aniso_47.avi');
v = VideoWriter('colored_movie.avi');
v.FrameRate = 5;
open(v);
f = 1;
while hasFrame(data) % for avi
% for f = 1:frames % for tif

    %% plot orginal movie
    Win = readFrame(data); % for avi
%     Win = imread('../data/iso_31.tif',f); % for tif
    psize = 3; 
    thresh = 20; 
    frametemp = bpass(Win(:,:,1),1,psize); 
    pk = pkfnd(frametemp,thresh,psize);
    cnt = cntrd(frametemp,pk,psize,0);
    cnt = cnt(:,[1,2])';
    cnt = [1:size(cnt,2);cnt]';
    subplot('Position',[0 0 1 1])
    imshow(Win)
    
    %% plot particles
    hold on
    CF = cnt;
    CF(:,2:3) = CF(:,2:3) * scale / a;
    [P_Type, GB_INFO, ~, Psi6, G_C6, ~, L_C6,~ ] = IMAGE_ANALYSIS(CF);
    Psi6 = min(Psi6/psi6Scale,1);
    G_C6 = min(G_C6/C6Scale,1);
    L_C6 = min(L_C6/C6Scale,1);
    for pt = 1:size(CF,1)
        if P_Type(pt) == -3 && G_C6>=0.7 && Psi6 <= 0.75 
            plot(cnt(pt,2),cnt(pt,3),'o','markersize', 4, ...
                'MarkerFaceColor','y','MarkerEdgeColor','y');
        else
            sc = scatter(cnt(pt,2),cnt(pt,3),30,...
                'MarkerFaceColor',[Psi6,0,L_C6(pt)],...
                'MarkerEdgeColor','none',...
                'MarkerFaceAlpha',L_C6(pt));
        end
    end
    
    %% plot grain boundary
    x_cn = mean(cnt(P_Type == -3, 2));
    y_cn = mean(cnt(P_Type == -3, 3));
    if G_C6>=0.8 && Psi6 <= 0.9
        plot((-50:50)*cos(GB_INFO(1)*pi/180)+x_cn,...
            (-50:50)*sin(GB_INFO(1)*pi/180)+y_cn,'w-','linewidth',2)
    end
    
    %% display OP
    descr= {sprintf('t:   %ds',f);...
        ['\psi_6: ', sprintf('%.2f',G_PSI6)];...
        ['C_6: ', sprintf('%.2f',G_C6)];...
        ['\alpha:   ', sprintf('%d^o',GB(f))]};
    text(25,-30,descr,'FontSize',14,'FontWeight','bold','color','g')
    annotation('rectangle',[0.13,0.12,.20,.25],...
        'FaceColor','white','FaceAlpha',1);
    annotation('textbox',[0.13,0.12,.20,.25],...
        'String',descr,'FontSize',12,'FontWeight','bold');
    hold off
    drawnow
    this_frame = getframe(gcf);
    writeVideo(v,this_frame.cdata);
    f = f + 1;
end
close(v)