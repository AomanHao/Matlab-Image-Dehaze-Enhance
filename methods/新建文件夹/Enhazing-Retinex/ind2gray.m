%ֱ��ͼ�Ҷȱ任
[X,map]=imread('forest.tif');
I=ind2gray(X,map);%������ͼ��ת��Ϊ�Ҷ�ͼ��
imshow(I);
title('ԭͼ��');
improfile%�����ѡ��һ���Խ��ߣ���ʾ�߶εĻҶ�ֵ
figure;subplot(121)
plot(0:0.01:1,sqrt(0:0.01:1))
axis square
title('ƽ�����Ҷȱ任����')
subplot(122)
maxnum=double(max(max(I)));%ȡ�ö�ά�������ֵ
J=sqrt(double(I)/maxnum);%����������ת����double,Ȼ�����ƽ�����任
%sqrt������֧��uint8����
J=uint8(J*maxnum);%����������ת����uint8����
imshow(J)
title('ƽ�����任���ͼ��')