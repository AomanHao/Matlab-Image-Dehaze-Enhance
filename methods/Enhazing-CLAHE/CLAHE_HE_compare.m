%% ������� 
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

clear
close all
clc
%% �Ҷ�ֱ��ͼ���⻯������HE��CLAHE��Ч���Ƚϣ�������ͼ����ǿ
img=imread('test.jpg');
figure;imshow(img),title('ԭʼͼ��');

%% HE��HSV�汾
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

%% HE��RGB�汾
rimg = img(:,:,1);
gimg = img(:,:,2);
bimg = img(:,:,3);
resultr = histeq(rimg);
resultg = histeq(gimg);
resultb = histeq(bimg);
result = cat(3, resultr, resultg, resultb);
figure;imshow(result),title('HE-RGB');

%% CLAHE��RGB�汾
rimg = img(:,:,1);
gimg = img(:,:,2);
bimg = img(:,:,3);
resultr = adapthisteq(rimg);
resultg = adapthisteq(gimg);
resultb = adapthisteq(bimg);
result = cat(3, resultr, resultg, resultb);
figure;imshow(result),title('CLAHE-RGB');
imwrite(result,'CLAHE.jpg');
%% CLAHE�ж�LAB��Lͨ���Ĵ���
cform2lab=makecform('srgb2lab');
LAB=applycform(img,cform2lab);
L=LAB(:,:,1);
LAB(:,:,1)=adapthisteq(L);
cform2srgb=makecform('lab2srgb');
J=applycform(LAB,cform2srgb);
figure;imshow(J),title('CLAHE-LAB-L');