%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

clear
close all
clc
%% 读取图像
I=imread('test.jpg');
figure;imshow(I);title('原图');
 
m=size(I,1);
n=size(I,2);
% 初始化矩阵
rr = zeros(m,n);
gg = zeros(m,n);
bb = zeros(m,n);
% eps的目的是防止分母出现0的时候产生正负无穷
 
% 如果反射率分量是乘性的，那需要变换到对数域
rr = log(double(I(:,:,1))+eps);
gg = log(double(I(:,:,2))+eps);
bb = log(double(I(:,:,3))+eps);
 
% 如果反射率分量是加性的，那只需要归一化就可以
% rr = double(rgb(:,:,1))+eps;
% gg = double(rgb(:,:,2))+eps;
% bb = double(rgb(:,:,3))+eps;
 
% 归一化
rr=rr/max(rr(:));
gg=gg/max(gg(:));
bb=bb/max(bb(:));
 
% Retinex算法
rrr = retinex_frankle_mccann(rr, 8);
ggg = retinex_frankle_mccann(gg, 8);
bbb = retinex_frankle_mccann(bb, 8);
 
% e^5.54约等于255，这里Retinex算法输出的是指数分量,每个像素亮度与该点计算结果x的关系为：I=255^x
rrr = round(exp(rrr.*5.54));
ggg = round(exp(ggg.*5.54));
bbb = round(exp(bbb.*5.54));
 
 
RGB = cat(3,uint8(rrr),uint8(ggg),uint8(bbb));
RGB = max(min(RGB,255),0);
 
figure;subplot(1,2,1);imshow(I);title('原图像');
subplot(1,2,2);imshow(RGB);title('新图像');
figure;subplot(1,2,1);imhist(rgb2gray(I));title('原图像的直方图');
subplot(1,2,2),imhist(rgb2gray(RGB));title('新图像的直方图');