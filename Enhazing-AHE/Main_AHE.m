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

%% AHE算法 参数不同效果不同
I_AHE_1=ahe(I,4,256);
figure;imshow(I_AHE_1);title('4256图');
imwrite(I_AHE_1,'AHE4256.jpg');
I_AHE_2=ahe(I,16,256);
figure;imshow(I_AHE_2);title('16256图');
imwrite(I_AHE_2,'AHE16256.jpg');
%% HE对比算法
I_HE=he(I);
figure;imshow(I_HE);title('he图');
imwrite(I_HE,'HE.jpg');