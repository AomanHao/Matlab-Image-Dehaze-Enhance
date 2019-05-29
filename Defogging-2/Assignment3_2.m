%暗通道算法
%http://blog.csdn.net/occupy8/article/details/40322683

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step1:得到暗通道图,彩色图三分量中取最小值后最小值滤波

img=imread('3.bmp');
figure('name','Fog');
imshow(img);
%取三通道中最小值
img_r=double(img(:,:,1));
img_g=double(img(:,:,2));
img_b=double(img(:,:,3));
[rowimg,colimg]=size(img);
row=rowimg;
col=round(colimg/3);

%机智的方法
img_dark=img_r.*(img_r<img_g)+img_g.*(img_r>=img_g);
img_dark=img_dark.*(img_dark<img_b)+img_b.*(img_dark>=img_b);

% 蠢的方法
% for i=1:row
%     for j=1:col
%         img_dark(i,j)=min(img_r(i,j),img_g(i,j));
%         img_dark(i,j)=min(img_dark(i,j),img_b(i,j));
%     end;
% end;

figure('name','img_dark');
imshow(uint8(img_dark));
imwrite(uint8(img_dark),'Dark Channel_0.jpg','jpg');

%窗口为win=15的最小值滤波
img_dark_filter=img_dark;
win=31;
r=15;

%最小值滤波
%机智的方法
% for i=1:row
%     for j=1:col
%         minwin=min(min(img_dark(max(1,i-r+1):min(i+r-1,row),max(1,j-r+1):min(j+r-1,col))));
%         %此种写法边框有色差
% %         minwin=img_dark_filter(i,j);
% %         if(i>=r&&i<=row-r&&j>=r&&j<=col-r)
% %             minwin=min(min(img_dark(i-r+1:i+r-1,j-r+1:j+r-1)));
% %         end;
%         img_dark_filter(i,j)=minwin;
%     end;
% end;

%均值滤波
for i=1:row
    for j=1:col
        meanwin=mean(mean(img_dark(max(1,i-r):min(i+r,row),max(1,j-r):min(j+r,col))));
        img_dark_filter(i,j)=meanwin;
    end;
end;

%蠢的方法
% for i=1:row
%     for j=1:col
%         minwin=255;
%         if(i>=r&&i<=row-r&&j>=r&&j<=col-r)
%             for s=-r+1:r-1
%                 for t=-r+1:r-1
%                     minwin=min(minwin,img_dark(i+s,j+t));
%                 end;
%             end;
%             img_dark_filter(i,j)=minwin;
%         end;
%     end;
% end;
            
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
%step3:求透射率t，t=1-w*min(min(I/A))，I是原图

% img_temp=I/A
img_temp_r=double(img(:,:,1))/min(220,A(1,1));
img_temp_g=double(img(:,:,2))/min(220,A(2,1));
img_temp_b=double(img(:,:,3))/min(220,A(3,1));
img_temp_min=img_temp_r.*(img_temp_r<img_temp_g)+img_temp_g.*(img_temp_r>=img_temp_g);
img_temp_min=img_temp_min.*(img_temp_min<img_temp_b)+img_temp_b.*(img_temp_min>=img_temp_b);

w=0.95;
t=ones(row,col)/10;
for i=1:row
    for j=1:col
        %最小值滤波
%         minwintemp=min(min(img_temp_min(max(1,i-r+1):min(i+r-1,row),max(1,j-r+1):min(j+r-1,col))));
%         t(i,j)=max(1-w*minwintemp,0.1);%限制t大于0.1
        %均值滤波
        meanwintemp=mean(mean(img_temp_min(max(1,i-r):min(i+r,row),max(1,j-r):min(j+r,col))));
        t(i,j)=max(1-w*meanwintemp,0.1);%限制t大于0.1
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step4:计算去雾图J=(I-A)/t+A，I是原图，J是去雾图

img_final=img;
for s=1:3
    Amatrix=A(s,1)*ones(row,col);
    img_final(:,:,s)=(double(img(:,:,s))-Amatrix)./t+Amatrix;
end;
figure('name','img_final');
imshow(img_final);
imwrite(img_final,'Fog Filter_Dark Channel.jpg','jpg');
