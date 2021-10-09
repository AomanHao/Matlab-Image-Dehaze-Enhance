clc
clear all
close all
%imageRGB = imread('picture.bmp');
%imageRGB = imread('shishi.jpg');
imageRGB = imread('traffic.jpg');
imageRGB = double(imageRGB);
imageRGB=imageRGB./255;
figure;
%subplot(2,1,1);
imshow(imageRGB), title('原始图像');
% imwrite(imageRGB(2:516,2:689,:),'D:\所有去雾程序\新建文件夹\双边滤波去雾\双边椒盐7(1)去雾截.bmp');
% subplot(2,1,2);imhist(rgb2gray(imageRGB));
% imageRGB=imnoise(imageRGB,'gaussian',0.02);
% figure;
% imshow(imageRGB);title('加噪图');
sz=size(imageRGB);
w=sz(2);
h=sz(1);

dark=darkChannel(imageRGB);
figure,imshow(dark);
title('暗通道图像');
% imwrite(dark,'traffic_1.jpg')
[m,n,~] = size(imageRGB);
%估计大气光值A，从暗通道中按亮度大小提取最亮的前0.1%像素。然后在原始有雾图像I中寻找对应位置上的具有最亮亮度的点的值，并以此作为A的值
imsize = m * n;
numpx = floor(imsize/1000);
JDarkVec = reshape(dark,imsize,1);
ImVec = reshape(imageRGB,imsize,3);

[JdarkVec, indices] = sort(JDarkVec);
indices = indices(imsize-numpx+1:end);

atmSum = zeros(1,3);
for ind = 1:numpx
    atmSum = atmSum + ImVec(indices(ind),:);
end
atmospheric = atmSum / numpx;

omega = 0.8;
im = zeros(size(imageRGB));

for ind = 1:3
    im(:,:,ind) = imageRGB(:,:,ind)./atmospheric(ind);
end
dark_2=darkChannel(im);%P15页对大气光归一化以后求取暗通道
t = 1-omega*dark_2;%对透射率粗估计
figure,imshow(t), title('原始透射图');
% imwrite(t,'traffic_2.jpg')
filter=0.9*bfltGray(t,1,3,0.1);
t_d = filter;
figure,imshow(t_d), title('双边滤波后透射图');
% imwrite(t_d,'traffic_3.jpg')
A = min(atmospheric);
% figure,imshow(t_d,[]),title('滤波后 t');
img_d = double(imageRGB);
% t_d = imadjust(t_d,[],[],0.5);
%J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,1));
%imwrite(J(:,:,1),'D:\桌面\学习\新建文件夹\双边滤波去雾\r.JPG');
%J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,2));
%imwrite(J(:,:,2),'D:\桌面\学习\新建文件夹\双边滤波去雾\g.JPG');
%J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,3));
%imwrite(J(:,:,3),'D:\桌面\学习\新建文件夹\双边滤波去雾\b.JPG');

J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%{
K=1;
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
%}
figure,imshow(J), title('去雾图像');
% imwrite(J,'D:\所有去雾程序\新建文件夹\双边滤波去雾\双边51去雾.bmp')
%imwrite(J(590.5:700,100:400,:),'traffic去雾.jpg')
%  imwrite(J(100:350,240:600,:),'双边椒盐8(1)局部去雾.bmp')






    




%{
clc
clear all
kenlRatio =0.01;
minAtomsLight = 215;
img=imread('traffic.jpg');
figure,imshow(uint8(img)), title('原始图像');
sz=size(img);
w=sz(2);
h=sz(1);
dc = zeros(h,w);
for y=1:h
    for x=1:w
        dc(y,x) = (img(y,x)); %计算图像暗通道
    end
end
 figure,imshow(uint8(dc)), title('暗通道灰度图像');
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio])); %确定滤波窗口的尺寸
dc2=0.9*bfltGray(dc,1,3,0.1);
dc2(h,w)=0;
% figure,imshow(uint8(dc2)), title('滤波后灰度图像 ');
t =255 - dc2; %对灰度值进行取反
t_d=double(t)/255; %确定大气透射率反向值
A = min([minAtomsLight, max(max(dc2))]); %确定大气光强
J = zeros(h,w,3);
img_d = double(img);
r = krnlsz*3;
eps = 10^-6;
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);%指导滤波t进行增强
t_d = filtered;
% figure,imshow(t_d,[]),title('滤波后 t');
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
figure,imshow(uint8(J)), title('去雾图像');
%}

