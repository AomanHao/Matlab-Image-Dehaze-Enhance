%均值滤波
%http://www.cnblogs.com/Imageshop/p/3410279.html
%基于单幅图像的快速去雾算法

img=imread('4.bmp');
figure('name','Fog');
imshow(img);

%step1:取三通道中最小值，M=min(img),并类似暗通道法计算A
%M
img_r=double(img(:,:,1));
img_g=double(img(:,:,2));
img_b=double(img(:,:,3));
[rowimg,colimg]=size(img);
row=rowimg;
col=round(colimg/3);

img_M=img_r.*(img_r<img_g)+img_g.*(img_r>=img_g);
img_M=img_M.*(img_M<img_b)+img_b.*(img_M>=img_b);

figure('name','img_M');
imshow(uint8(img_M));

%step2：M均值滤波，A(x,y)=average(M)
win=31;
r=15;
for i=1:row
    for j=1:col
        meanwin=mean(mean(img_M(max(1,i-r):min(i+r,row),max(1,j-r):min(j+r,col))));
        img_Mav(i,j)=meanwin;
    end;
end;
figure('name','img_Mav');
imshow(uint8(img_Mav));

%step3：M所有元素平均值
mav=mean(img_M(:))/255;

%step4:用Mav求L
p=2.3;%去雾因子，越大效果好,p:0~1/mav
temp1=min(p*mav,0.9)*img_Mav;
img_L=temp1.*(temp1<img_M)+img_M.*(temp1>=img_M);
figure('name','img_L');
imshow(uint8(img_L));

%step5:Mav和img求A，三通道A相等
temp2=max(max(max(img)));
temp3=max(max(img_Mav));
A=0.5*(double(temp2)+double(temp3));%matlab自己给定上限255

%step6:求去雾图
unit=ones(row,col);
for s=1:3
    img_final(:,:,s)=(double(img(:,:,s))-img_L)./(unit-img_L/double(A));
end;

img_final_r=img_final(:,:,1);
img_final_g=img_final(:,:,2);
img_final_b=img_final(:,:,3);

figure('name','img_final');
imshow(uint8(img_final));
imwrite(uint8(img_final),'Fog Filter_Average Filter.jpg','jpg');
