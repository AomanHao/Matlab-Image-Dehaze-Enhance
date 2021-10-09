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
imshow(imageRGB), title('ԭʼͼ��');
% imwrite(imageRGB(2:516,2:689,:),'D:\����ȥ�����\�½��ļ���\˫���˲�ȥ��\˫�߽���7(1)ȥ���.bmp');
% subplot(2,1,2);imhist(rgb2gray(imageRGB));
% imageRGB=imnoise(imageRGB,'gaussian',0.02);
% figure;
% imshow(imageRGB);title('����ͼ');
sz=size(imageRGB);
w=sz(2);
h=sz(1);

dark=darkChannel(imageRGB);
figure,imshow(dark);
title('��ͨ��ͼ��');
% imwrite(dark,'traffic_1.jpg')
[m,n,~] = size(imageRGB);
%���ƴ�����ֵA���Ӱ�ͨ���а����ȴ�С��ȡ������ǰ0.1%���ء�Ȼ����ԭʼ����ͼ��I��Ѱ�Ҷ�Ӧλ���ϵľ����������ȵĵ��ֵ�����Դ���ΪA��ֵ
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
dark_2=darkChannel(im);%P15ҳ�Դ������һ���Ժ���ȡ��ͨ��
t = 1-omega*dark_2;%��͸���ʴֹ���
figure,imshow(t), title('ԭʼ͸��ͼ');
% imwrite(t,'traffic_2.jpg')
filter=0.9*bfltGray(t,1,3,0.1);
t_d = filter;
figure,imshow(t_d), title('˫���˲���͸��ͼ');
% imwrite(t_d,'traffic_3.jpg')
A = min(atmospheric);
% figure,imshow(t_d,[]),title('�˲��� t');
img_d = double(imageRGB);
% t_d = imadjust(t_d,[],[],0.5);
%J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,1));
%imwrite(J(:,:,1),'D:\����\ѧϰ\�½��ļ���\˫���˲�ȥ��\r.JPG');
%J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,2));
%imwrite(J(:,:,2),'D:\����\ѧϰ\�½��ļ���\˫���˲�ȥ��\g.JPG');
%J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,3));
%imwrite(J(:,:,3),'D:\����\ѧϰ\�½��ļ���\˫���˲�ȥ��\b.JPG');

J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%{
K=1;
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
%}
figure,imshow(J), title('ȥ��ͼ��');
% imwrite(J,'D:\����ȥ�����\�½��ļ���\˫���˲�ȥ��\˫��51ȥ��.bmp')
%imwrite(J(590.5:700,100:400,:),'trafficȥ��.jpg')
%  imwrite(J(100:350,240:600,:),'˫�߽���8(1)�ֲ�ȥ��.bmp')






    




%{
clc
clear all
kenlRatio =0.01;
minAtomsLight = 215;
img=imread('traffic.jpg');
figure,imshow(uint8(img)), title('ԭʼͼ��');
sz=size(img);
w=sz(2);
h=sz(1);
dc = zeros(h,w);
for y=1:h
    for x=1:w
        dc(y,x) = (img(y,x)); %����ͼ��ͨ��
    end
end
 figure,imshow(uint8(dc)), title('��ͨ���Ҷ�ͼ��');
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio])); %ȷ���˲����ڵĳߴ�
dc2=0.9*bfltGray(dc,1,3,0.1);
dc2(h,w)=0;
% figure,imshow(uint8(dc2)), title('�˲���Ҷ�ͼ�� ');
t =255 - dc2; %�ԻҶ�ֵ����ȡ��
t_d=double(t)/255; %ȷ������͸���ʷ���ֵ
A = min([minAtomsLight, max(max(dc2))]); %ȷ��������ǿ
J = zeros(h,w,3);
img_d = double(img);
r = krnlsz*3;
eps = 10^-6;
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);%ָ���˲�t������ǿ
t_d = filtered;
% figure,imshow(t_d,[]),title('�˲��� t');
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
figure,imshow(uint8(J)), title('ȥ��ͼ��');
%}

