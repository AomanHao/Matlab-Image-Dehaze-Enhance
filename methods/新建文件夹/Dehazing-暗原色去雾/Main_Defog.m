
%% ������� 
% �����ʵ��ѧͼ�����Ŷ�-�º�
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------
clc;
clear;
close all;

%% -----------ͼ��ȥ���㷨----------------
%% ����ͼƬ
img = imread('foggy_bench.jpg');
figure;imshow(img);title('��ͼ');
%% ȥ����
De_img = anyuanse(img);
figure;imshow(De_img);title('ȥ��ͼ');
%% ���������ֱ���300dpi������ΪtiffͼƬ
imwrite(De_img,'1.tiff','tiff','Resolution',300);
