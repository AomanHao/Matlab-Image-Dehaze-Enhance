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

%% AHE�㷨 ������ͬЧ����ͬ
I_AHE_1=ahe(I,4,256);
figure;imshow(I_AHE_1);title('4256ͼ');
imwrite(I_AHE_1,'AHE4256.jpg');
I_AHE_2=ahe(I,16,256);
figure;imshow(I_AHE_2);title('16256ͼ');
imwrite(I_AHE_2,'AHE16256.jpg');
%% HE�Ա��㷨
I_HE=he(I);
figure;imshow(I_HE);title('heͼ');
imwrite(I_HE,'HE.jpg');