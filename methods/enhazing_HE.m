function output = enhazing_HE(input)
%% ֱ��ͼ����

img_his = rgb2hsi(uint8(input));
img_H=img_his(:,:,1);
img_S=img_his(:,:,2);
img_I=img_his(:,:,3);

%% ����ǰ�Ҷ�ֱ��ͼ
[h,w,c] = size(input);
len = h*w;
[HisI,len] = hist(I,255);
HisI = HisI/length(I);
% figure;bar(HisI),title('����ǰֱ��ͼ');
%% �Ҷ�ֱ��ͼ����
IE = histeq(img_I);
[HisI2,len] = hist(IE,255);
HisI2 = HisI2/length(IE);
% figure;bar(HisI2),title('�����ֱ��ͼ');

RV = cat(3,img_H,img_S,IE);
output = hsi2rgb(RV);
% figure;imshow(img_his),title('HSI ͼ��');
% figure;imshow(output),title('RGB ���Ⱦ���');