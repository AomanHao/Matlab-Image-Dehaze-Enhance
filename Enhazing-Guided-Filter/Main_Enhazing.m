%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
%
% 何凯明作者论文及代码地址http://kaiminghe.com/eccv10/
% figure 6 in our paper
%--------------------------------------

clear
close all
clc
%% 读取图像及参数
I=imread('3096.jpg');
I = double(I)./ 255;
p = I;
figure;imshow(I);title('原始图像');
r = 16;
eps = 0.1^2;
sigma = 4;%叠加残差的倍数
q = zeros(size(I));
%% 彩色图像引导滤波
q(:, :, 1) = guidedfilter(I(:, :, 1), p(:, :, 1), r, eps);
q(:, :, 2) = guidedfilter(I(:, :, 2), p(:, :, 2), r, eps);
q(:, :, 3) = guidedfilter(I(:, :, 3), p(:, :, 3), r, eps);
figure;imshow(q);title('导向滤波图像');
%% 滤波图与未滤波图的残差
w = (I - q);
figure;imshow(w);title('残差图像');
I_enh = w * sigma + I;
figure;imshow(I_enh);title('增强图像');
