% clear
% clc
ruler = -40:0.25:40;
d_field = load('../fields/10v4.txt');
xx = [];
yy= [];
zz = [];
Ex = [];
Ey = [];
dEx = [];
dEy = [];
Ez = [];
while(~isempty(d_field))
    xx = cat(2,xx, d_field(1:size(ruler,2),1));
    yy = cat(2,yy, d_field(1:size(ruler,2),2));
    Ex = cat(2,Ex, d_field(1:size(ruler,2),3));
    Ey = cat(2,Ey, d_field(1:size(ruler,2),4));
    d_field(1:size(ruler,2),:) = [];
end
E = (Ex.^2 + Ey.^2)*21.86/0.4667;
K = 0.006*ones(15);
E = conv2(E,K,'same');
figure(10)
clf
% colormap(jet)
% colormap( flipud(gray(256)) )
% contourf(xx,yy,(E), 30);% quad
% contourf(xx,yy,(E), 30);
contourf(xx,yy,rot90(E), 100);%10v4
colorbar
pbaspect([1 1 1])
