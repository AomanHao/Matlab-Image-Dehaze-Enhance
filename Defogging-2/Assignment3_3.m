%暗通道算法+导向滤波
%http://blog.csdn.net/occupy8/article/details/40322683
%http://wenku.baidu.com/link?url=czQLqmyPV0PoeNg_gCKkD5Cj716UT10XYyYdhv3RaM_n3yJSyepxywMpVxZMDO1RjykbAe2LL0JVxuVK3ef5_PBO9U3zEI9eSW5weGU8a4y

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step1:得到暗通道图,彩色图三分量中取最小值后最小值滤波

img=imread('10.bmp');
figure('name','Fog');
imshow(img);
%取三通道中最小值
img_r=double(img(:,:,1));
img_g=double(img(:,:,2));
img_b=double(img(:,:,3));
[rowimg,colimg]=size(img);
row=rowimg;
col=round(colimg/3);

img_dark=img_r.*(img_r<img_g)+img_g.*(img_r>=img_g);
img_dark=img_dark.*(img_dark<img_b)+img_b.*(img_dark>=img_b);

%窗口为win=15的最小值滤波
img_dark_filter=img_dark;
win=41;
r=20;

%最小值滤波
for i=1:row
    for j=1:col
        minwin=min(min(img_dark(max(1,i-r):min(i+r,row),max(1,j-r):min(j+r,col))));
        img_dark_filter(i,j)=minwin;
    end;
end;

figure('name','img_dark_filter');
imshow(uint8(img_dark_filter));
imwrite(uint8(img_dark_filter),'Dark Channel.jpg','jpg');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %step2:求全球大气光因数A，取暗通道亮度前0.1%，此位置在原图中找最高亮度即A

%找暗通道亮度前0.1%像素点位置
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step3:导向滤波求更精细的透射率t，灰度图为导向图I，p为暗通道最小值滤波图
I=double(rgb2gray(img));
p=double(img_dark_filter);
r1=20;%大于最小值滤波的4倍
e=0.001;

var_I=zeros(row,col);
mean_I=zeros(row,col);
mean_p=zeros(row,col);
mean_Ip=zeros(row,col);

for i=1:row
    for j=1:col
        %确定窗口位置
        rmin=max(1,i-r1);
        rmax=min(row,i+r1);
        cmin=max(1,j-r1);
        cmax=min(col,j+r1);
        w=(rmax-rmin+1)*(cmax-cmin+1);%窗口内点数
        win_I=I(rmin:rmax,cmin:cmax);
        win_p=p(rmin:rmax,cmin:cmax);
        var_I(i,j)=std2(win_I);%I窗口内标准差
        mean_I(i,j)=mean(mean(win_I));%I窗口内均值
        mean_p(i,j)=mean(mean(win_p));%p窗口内均值
        mean_Ip(i,j)=mean(mean(win_I.*win_p));%p窗口内均值
    end;
end;
a=(mean_Ip-mean_I.*mean_p)./(var_I.*var_I)+e;
b=mean_p-a.*mean_I;
q=(a.*I+b)/w;%这里实际w不对

figure('name','img_fog_q');
imshow(q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step4:计算去雾图J=(I-A)/t+A，I是原图，J是去雾图

t=q;
img_final=img;
for s=1:3
    Amatrix=A(s,1)*ones(row,col);
    img_final(:,:,s)=(double(img(:,:,s))-Amatrix)./t+Amatrix;
end;
figure('name','img_final');
imshow(img_final);
imwrite(img_final,'Fog Filter_Dark Channel+Guide Filter.jpg','jpg');


        
    
    