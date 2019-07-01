clear
clc
close all
v1 = VideoReader('~/Desktop/mov2.avi');
v2 = VideoWriter('~/Desktop/mov2.avi');
v2.FrameRate = 10;
open(v2)
f = read(v1);
writeVideo(v2,f)
close(v2)