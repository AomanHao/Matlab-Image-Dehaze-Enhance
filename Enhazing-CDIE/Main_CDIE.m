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
%% Enhance
HSV = rgb2hsv(I);
H=HSV(:,:,1);
S=HSV(:,:,2);
V=HSV(:,:,3);
figure,imshow(H)
figure, imshow(S);
figure, imshow(V);
O = HSV;
O(:,:,3) =divChannel(V,5,10,0.8,[3 1 1/2],[85 170]);

figure('name','Enhanced'), imshow(hsv2rgb(O));