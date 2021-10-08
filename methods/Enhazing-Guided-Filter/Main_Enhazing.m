%% ������� 
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
%
% �ο����������ļ������ַhttp://kaiminghe.com/eccv10/
% figure 6 in our paper
%--------------------------------------

clear
close all
clc
%% ��ȡͼ�񼰲���
I=imread('3096.jpg');
I = double(I)./ 255;
p = I;
figure;imshow(I);title('ԭʼͼ��');
r = 16;
eps = 0.1^2;
sigma = 4;%���Ӳв�ı���
q = zeros(size(I));
%% ��ɫͼ�������˲�
q(:, :, 1) = guidedfilter(I(:, :, 1), p(:, :, 1), r, eps);
q(:, :, 2) = guidedfilter(I(:, :, 2), p(:, :, 2), r, eps);
q(:, :, 3) = guidedfilter(I(:, :, 3), p(:, :, 3), r, eps);
figure;imshow(q);title('�����˲�ͼ��');
%% �˲�ͼ��δ�˲�ͼ�Ĳв�
w = (I - q);
figure;imshow(w);title('�в�ͼ��');
I_enh = w * sigma + I;
figure;imshow(I_enh);title('��ǿͼ��');
