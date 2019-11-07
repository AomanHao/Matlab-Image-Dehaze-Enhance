%% 程序分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------
clear
close all
clc
%% 灰度直方图均衡化方法，HE与CLAHE的效果比较，可用于图像增强
img=imread('test.jpg');
figure;imshow(img),title('原始图像');

%% HE的HSV版本
hsvImg = rgb2hsv(img);  
V=hsvImg(:,:,3);  
[height,width]=size(V);  
V = uint8(V*255);  
NumPixel = zeros(1,256);  
for i = 1:height  
    for j = 1: width  
    NumPixel(V(i,j) + 1) = NumPixel(V(i,j) + 1) + 1;  
    end  
end  
ProbPixel = zeros(1,256);  
for i = 1:256  
    ProbPixel(i) = NumPixel(i) / (height * width * 1.0);  
end    
CumuPixel = cumsum(ProbPixel);  
CumuPixel = uint8(255 .* CumuPixel + 0.5);    
for i = 1:height  
    for j = 1: width  
        V(i,j) = CumuPixel(V(i,j));  
    end  
end  
V = im2double(V);  
hsvImg(:,:,3) = V;  
outputImg = hsv2rgb(hsvImg);
figure;imshow(outputImg),title('HE-HSV');

%% HE的RGB版本
rimg = img(:,:,1);
gimg = img(:,:,2);
bimg = img(:,:,3);
resultr = histeq(rimg);
resultg = histeq(gimg);
resultb = histeq(bimg);
result = cat(3, resultr, resultg, resultb);
figure;imshow(result),title('HE-RGB');

%% CLAHE的RGB版本
rimg = img(:,:,1);
gimg = img(:,:,2);
bimg = img(:,:,3);
resultr = adapthisteq(rimg);
resultg = adapthisteq(gimg);
resultb = adapthisteq(bimg);
result = cat(3, resultr, resultg, resultb);
figure;imshow(result),title('CLAHE-RGB');

%% CLAHE中对LAB的L通道的处理
cform2lab=makecform('srgb2lab');
LAB=applycform(img,cform2lab);
L=LAB(:,:,1);
LAB(:,:,1)=adapthisteq(L);
cform2srgb=makecform('lab2srgb');
J=applycform(LAB,cform2srgb);
figure;imshow(J),title('CLAHE-LAB-L');
%