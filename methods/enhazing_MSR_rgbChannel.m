function [MSR1,SSR1,Rr_final] = enhazing_MSR_rgbChannel(input_channel,Gauss_1,Gauss_2,Gauss_3,conf)
%% -----------���߶�����Ĥ��ǿ��RGBͨ������---------------

G = conf.MSR_G;
b = conf.MSR_b;
alpha = conf.MSR_alpha;
beta = conf.MSR_beta;
%% %%%%%%%%�Ե���������%%%%%%% 
% MSR���� 
input_channel = double(input_channel);
I_log=log(input_channel+1);  %��ͼ��ת���������� 
I_fft=fft2(input_channel);  %��ͼ����и���Ҷ�任,ת����Ƶ���� 

%sigam=15�Ĵ����� 
fgauss=fft2(Gauss_1,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss);  %��Ƶ�������Ƶ���� 
Rr=ifft2(fgauss.*I_fft);  %�������任�ؿ����� 
min1=min(min(Rr)); 
Rr_log= log(Rr - min1+1); 
Rr1=I_log-Rr_log;  

%sigam=80 
fgauss=fft2(Gauss_2,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss); 
Rr= ifft2(fgauss.*I_fft); 
min1=min(min(Rr)); 
Rr_log= log(Rr - min1+1); 
Rr2=I_log-Rr_log;  

 %sigam=250 
fgauss=fft2(Gauss_3,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss); 
Rr= ifft2(fgauss.*I_fft); 
min1=min(min(Rr)); 
Rr_log= log(Rr - min1+1); 
Rr3=I_log-Rr_log; 

Rr=0.33*Rr1+0.34*Rr2+0.33*Rr3;   %��Ȩ��� 
MSR1 = Rr;
SSR1 = Rr2;
%����CR 
CRr = beta*(log(alpha*input_channel+1)-log(input_channel+Ig_double+Ib_double+1)); 

%% MSRCR ��ɫ�ʻָ��Ķ�߶�����Ĥ��ǿ�㷨��MSRCR��
Rr = G*(CRr.*Rr+b); 
min1 = min(min(Rr)); 
max1 = max(max(Rr)); 
Rr_final = uint8(255*(Rr-min1)/(max1-min1)); 
