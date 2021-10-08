%各种色彩空间中的直方图均衡化
%http://www.ilovematlab.cn/thread-221151-1-1.html

img=imread('5.bmp');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%直接在RGB空间直方图均衡化
img_r=img(:,:,1);
img_g=img(:,:,2);
img_b=img(:,:,3);
img_R=histeq(img_r);
img_G=histeq(img_g);
img_B=histeq(img_b);
img_RGB=cat(3,img_R,img_G,img_B);
figure('name','img_RGB');
imshow(img_RGB);
imwrite(img_RGB,'RGB histeq.jpg','jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%
%转化到HSV空间直方图均衡化
img_hsv=rgb2hsv(img);
img_h=img_hsv(:,:,1);
img_s=img_hsv(:,:,2);
img_v=img_hsv(:,:,3);
% img_H=histeq(img_h);
img_S=histeq(img_s);
img_V=histeq(img_v);
img_HSV=hsv2rgb(img_h,img_S,img_V);
figure('name','img_HSV');
imshow(img_HSV);
imwrite(img_HSV,'HSV histeq.jpg','jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%转化到YCbCr空间直方图均衡化
img_ycbcr=rgb2ycbcr(img);
img_y=img_ycbcr(:,:,1);
img_cb=img_ycbcr(:,:,2);
img_cr=img_ycbcr(:,:,3);
img_Y=histeq(img_y);
img_YCBCR=ycbcr2rgb(cat(3,img_Y,img_cb,img_cr));
figure('name','img_YCBCR');
imshow(img_YCBCR);
imwrite(img_YCBCR,'YCBCR histeq.jpg','jpg');
