%% 程序整理分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% --------------------------------------

clear
close all
clc
%% 读取图像
I=imread('test.jpg');
figure;imshow(I);title('原图');
HSI_f = rgb2hsi(uint8(I));
H=HSI_f(:,:,1);
S=HSI_f(:,:,2);
I=HSI_f(:,:,3);

%% 均衡前灰度直方图
[h,w,c] = size(f_lag);
len = h*w;
[HisI,len] = hist(I,255);
HisI = HisI/length(I);
figure(2),bar(HisI),title('均衡前直方图');
%% 灰度直方图均衡
IE = histeq(I);
[HisI2,len] = hist(IE,255);
HisI2 = HisI2/length(IE);
figure(3),bar(HisI2),title('均衡后直方图');

RV = cat(3,H,S,IE);
C = hsi2rgb(RV);
figure(4),imshow(HSI_f),title('HSI 图像');
figure(5),imshow(C),title('RGB 亮度均匀');