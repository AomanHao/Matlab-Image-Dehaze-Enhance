%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
%%
%2019年10月20日-2019年10月21日
%论文：An Integrated Neighborhood Dependent Approach for Nonlinear Enhancement of Color Images

clear
close all
clc
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=im2double(imread('test.jpg'));
img=rgb2gray(I);

%% 线性增强
In=(img.^(0.24)+(1-img).*0.5+img.^2)/2;

%% 高斯核做卷积运算
sigma=5;% 高斯滤波标准差
window = double(uint8(3*sigma)*2 + 1);%邻域矩阵直径
G1=fspecial('gaussian',window,sigma);%高斯卷积矩阵
Guassimg=imfilter(img,G1,'conv','replicate','same');% 复制边缘数值卷积
r1=Guassimg./img;
R1=In.^r1;
figure;imshow(R1);

sigma=20;
window = double(uint8(3*sigma)*2 + 1);
G2=fspecial('gaussian',window,sigma);
Guass2=imfilter(img,G2,'conv','replicate','same');
r2=Guass2./img;
R2=In.^r2;
figure;imshow(R2);

sigma=240;
window = double(uint8(3*sigma)*2 + 1);
G3=fspecial('gaussian',window,sigma);
Guass3=imfilter(img,G3,'conv','replicate','same');
r3=Guass3./img;
R3=In.^r3;
figure;imshow(R3);
%% 色彩恢复
R=(R1+R2+R3)/3;
figure;imshow(R3);
Rr=R.*(I(:,:,1)./img);
Rg=R.*(I(:,:,2)./img);
Rb=R.*(I(:,:,3)./img);
rgb=cat(3,Rr,Rg,Rb);% 合并3维矩阵
figure;imshow(I);
figure;imshow(rgb);
imwrite(rgb,'result.jpg');%保存为tif
