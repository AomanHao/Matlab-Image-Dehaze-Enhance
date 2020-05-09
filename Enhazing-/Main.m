%%
%2019年10月20日-2019年10月21日
%论文：An Integrated Neighborhood Dependent Approach for Nonlinear Enhancement of Color Images
clc
clear
I=im2double(imread('3096.jpg'));
I1=rgb2gray(I);
In=(I1.^(0.24)+(1-I1).*0.5+I1.^2)/2;

%通过高斯核对灰度增强图像做卷积运算
sigma=5;
window = double(uint8(3*sigma)*2 + 1);
G1=fspecial('gaussian',window,sigma);
Guass1=imfilter(I1,G1,'conv','replicate','same');
r1=Guass1./I1;
R1=In.^r1;
sigma=20;
window = double(uint8(3*sigma)*2 + 1);
G2=fspecial('gaussian',window,sigma);
Guass2=imfilter(I1,G2,'conv','replicate','same');
r2=Guass2./I1;
R2=In.^r2;
sigma=240;
window = double(uint8(3*sigma)*2 + 1);
G3=fspecial('gaussian',window,sigma);
Guass3=imfilter(I1,G3,'conv','replicate','same');
r3=Guass3./I1;
R3=In.^r3;
R=(R1+R2+R3)/3;
Rr=R.*(I(:,:,1)./I1);
Rg=R.*(I(:,:,2)./I1);
Rb=R.*(I(:,:,3)./I1);
rgb=cat(3,Rr,Rg,Rb);
imshow([I rgb]);
