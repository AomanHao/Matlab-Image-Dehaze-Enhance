%% ������� 
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

clear
close all
clc
%% ��ȡͼ��
I=imread('test.jpg');
figure;imshow(I);title('ԭͼ');
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