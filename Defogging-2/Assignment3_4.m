%中值滤波
%http://www.cnblogs.com/Imageshop/p/3458963.html

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

%A，完全同3_3
%找暗通道亮度前0.1%像素点位置
win=21;
r=15;
for i=1:row
    for j=1:col
        meanwin=min(min(img_M(max(1,i-r):min(i+r,row),max(1,j-r):min(j+r,col))));
        img_dark_filter(i,j)=meanwin;
    end;
end;

img_dark_sort=sort(img_dark_filter(:));
num=round(row*col*0.001);
shred=img_dark_sort(row*col-num+1,1);
[pos_r,pos_c,value]=find(img_dark_filter>=shred,num);

A=zeros(3,1);
maxgray=zeros(3,num);
for s=1:3%三个通道分别取最大值 
    for i=1:num%从原图取出以上位置的值
        maxgray(s,i)=img(pos_r(i,1),pos_c(i,1),s);
    end;
    maxgray=sort(maxgray,2);
    A(s,1)=maxgray(s,num);
end;

%step2：中值滤波，A(x,y)=median(M)
r1=20;
img_A=medfilt2(img_M,[r1,r1]);
figure('name','img_A');
imshow(uint8(img_A));

%step3：B=A-median(abs(A-M))
img_B=img_A-medfilt2(abs(img_A-img_M),[r1,r1]);
figure('name','img_B');
imshow(uint8(img_B));

%step4：计算雾浓度，F=max(min(p*B),M,0),去雾因子p:0~1
p=0.95;
zero=zeros(row,col);
temp1=p*img_B;
temp2=temp1.*(temp1<img_M)+img_M.*(temp1>=img_M);
img_F=temp2.*(temp2>=zero)+zero.*(temp2<zero);
figure('name','img_F');
imshow(uint8(img_F));

%step5：计算去雾,J=(I-F)/(1-F/A)
unit=ones(row,col);
for s=1:3
    img_final(:,:,s)=(double(img(:,:,s))-img_F)./max(0.2,(unit-(img_F/A(s,1))));
%     img_final(:,:,s)=(double(img(:,:,s))-img_F)./(unit-(img_F/A(s,1)));
    maxtemp=max(max(img_F/A(s,1)));
    mintemp=min(min(img_F/A(s,1)));
end;

img_final_r=img_final(:,:,1);
img_final_g=img_final(:,:,2);
img_final_b=img_final(:,:,3);

figure('name','img_final');
imshow(uint8(img_final));
imwrite(uint8(img_final),'Fog Filter_Median Filter.jpg','jpg');







