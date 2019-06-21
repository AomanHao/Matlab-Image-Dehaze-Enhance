
%% 程序分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------
clc;
clear;
close all;

%% -----------图像去雾算法----------------

%% 加载图片
img = imread('foggy_bench.jpg');
figure;imshow(img);title('雾图');
%% 去雾函数
De_img = anyuanse(img);
figure;imshow(De_img);title('去雾图');
%% 输出结果，分辨率300dpi并保存为tiff图片
imwrite(De_img,'1.tiff','tiff','Resolution',300);
