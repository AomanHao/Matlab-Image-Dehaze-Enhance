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
 
m=size(I,1);
n=size(I,2);
% ��ʼ������
rr = zeros(m,n);
gg = zeros(m,n);
bb = zeros(m,n);
% eps��Ŀ���Ƿ�ֹ��ĸ����0��ʱ�������������
 
% ��������ʷ����ǳ��Եģ�����Ҫ�任��������
rr = log(double(I(:,:,1))+eps);
gg = log(double(I(:,:,2))+eps);
bb = log(double(I(:,:,3))+eps);
 
% ��������ʷ����Ǽ��Եģ���ֻ��Ҫ��һ���Ϳ���
% rr = double(rgb(:,:,1))+eps;
% gg = double(rgb(:,:,2))+eps;
% bb = double(rgb(:,:,3))+eps;
 
% ��һ��
rr=rr/max(rr(:));
gg=gg/max(gg(:));
bb=bb/max(bb(:));
 
% Retinex�㷨
rrr = retinex_frankle_mccann(rr, 8);
ggg = retinex_frankle_mccann(gg, 8);
bbb = retinex_frankle_mccann(bb, 8);
 
% e^5.54Լ����255������Retinex�㷨�������ָ������,ÿ������������õ������x�Ĺ�ϵΪ��I=255^x
rrr = round(exp(rrr.*5.54));
ggg = round(exp(ggg.*5.54));
bbb = round(exp(bbb.*5.54));
 
 
RGB = cat(3,uint8(rrr),uint8(ggg),uint8(bbb));
RGB = max(min(RGB,255),0);
 
figure;subplot(1,2,1);imshow(I);title('ԭͼ��');
subplot(1,2,2);imshow(RGB);title('��ͼ��');
figure;subplot(1,2,1);imhist(rgb2gray(I));title('ԭͼ���ֱ��ͼ');
subplot(1,2,2),imhist(rgb2gray(RGB));title('��ͼ���ֱ��ͼ');