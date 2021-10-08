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
HSI_f = rgb2hsi(uint8(I));
H=HSI_f(:,:,1);
S=HSI_f(:,:,2);
I=HSI_f(:,:,3);

%% ����ǰ�Ҷ�ֱ��ͼ
[h,w,c] = size(f_lag);
len = h*w;
[HisI,len] = hist(I,255);
HisI = HisI/length(I);
figure(2),bar(HisI),title('����ǰֱ��ͼ');
%% �Ҷ�ֱ��ͼ����
IE = histeq(I);
[HisI2,len] = hist(IE,255);
HisI2 = HisI2/length(IE);
figure(3),bar(HisI2),title('�����ֱ��ͼ');

RV = cat(3,H,S,IE);
C = hsi2rgb(RV);
figure(4),imshow(HSI_f),title('HSI ͼ��');
figure(5),imshow(C),title('RGB ���Ⱦ���');