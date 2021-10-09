function output = enhazing_HE(input)
%% 直方图均衡

img_his = rgb2hsi(uint8(input));
img_H=img_his(:,:,1);
img_S=img_his(:,:,2);
img_I=img_his(:,:,3);

%% 均衡前灰度直方图
[h,w,c] = size(input);
len = h*w;
[HisI,len] = hist(I,255);
HisI = HisI/length(I);
% figure;bar(HisI),title('均衡前直方图');
%% 灰度直方图均衡
IE = histeq(img_I);
[HisI2,len] = hist(IE,255);
HisI2 = HisI2/length(IE);
% figure;bar(HisI2),title('均衡后直方图');

RV = cat(3,img_H,img_S,IE);
output = hsi2rgb(RV);
% figure;imshow(img_his),title('HSI 图像');
% figure;imshow(output),title('RGB 亮度均匀');