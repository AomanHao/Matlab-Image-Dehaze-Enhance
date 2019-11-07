%直方图灰度变换
[X,map]=imread('forest.tif');
I=ind2gray(X,map);%把索引图像转换为灰度图像
imshow(I);
title('原图像');
improfile%用鼠标选择一条对角线，显示线段的灰度值
figure;subplot(121)
plot(0:0.01:1,sqrt(0:0.01:1))
axis square
title('平方根灰度变换函数')
subplot(122)
maxnum=double(max(max(I)));%取得二维数组最大值
J=sqrt(double(I)/maxnum);%把数据类型转换成double,然后进行平方根变换
%sqrt函数不支持uint8类型
J=uint8(J*maxnum);%把数据类型转换成uint8类型
imshow(J)
title('平方根变换后的图像')