clear
clc
addpath('./Image_Analysis_v0626');
warning off
set(0,'DefaultFigureWindowStyle','docked')
scale = 1214*(4/8)*(40/63)*(1/1)/1000;
OP_file = load('./data/Cycle_101_OP.txt');
frame = size(OP_file,1);
pnum = 300;
a = 1.435;
v = VideoWriter('const.avi');
v.FrameRate = 15;
open(v);
for f = 1:frame
    Win = imread('./data/Cycle_101.tif',f);
    psize = 3; 
    thresh = 20; 
    frametemp = bpass(Win,1,psize); 
    pk = pkfnd(frametemp,thresh,psize);
    cnt = cntrd(frametemp,pk,psize,0);
    cnt = cnt(:,[1,2])';
    cnt = [1:size(cnt,2);cnt]';
    imshow(Win)
    hold on
    CF = cnt;
    CF(:,2:3) = CF(:,2:3) * scale / a;
    [P_Type, GB, domain, Psi6, G_C6, ~, L_C6,theta] = IMAGE_ANALYSIS(CF);
    tt = 0;
    for pt = 1:size(CF,1)
        if P_Type(pt) == -3 && G_C6>=0.8 && Psi6 <= 0.93 
            plot(cnt(pt,2),cnt(pt,3),'o','markersize', 8, ...
                'MarkerFaceColor','y','MarkerEdgeColor','y');
        else
            sc = scatter(cnt(pt,2),cnt(pt,3),80,...
                'MarkerFaceColor',[Psi6,0,L_C6(pt)],...
                'MarkerEdgeColor','none',...
                'MarkerFaceAlpha',L_C6(pt));
        end
    end
    hold off
    title(num2str(f));
    axis([40, 296, 20.5, 256.5])
    drawnow
    this_frame = getframe(gcf);
    writeVideo(v,this_frame.cdata);
end
close(v)