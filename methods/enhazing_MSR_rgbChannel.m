function [MSR1,SSR1,Rr_final] = enhazing_MSR_rgbChannel(input_channel,Gauss_1,Gauss_2,Gauss_3,conf)
%% -----------单尺度视网膜增强—RGB通道处理---------------

G = conf.MSR_G;
b = conf.MSR_b;
alpha = conf.MSR_alpha;
beta = conf.MSR_beta;
%% %%%%%%%%对单分量操作%%%%%%% 
% MSR部分 
input_channel = double(input_channel);
I_log=log(input_channel+1);  %将图像转换到对数域 
I_fft=fft2(input_channel);  %对图像进行傅立叶变换,转换到频域中 

%sigam=15的处理结果 
fgauss=fft2(Gauss_1,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss);  %将频域中心移到零点 
Rr=ifft2(fgauss.*I_fft);  %做卷积后变换回空域中 
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

Rr=0.33*Rr1+0.34*Rr2+0.33*Rr3;   %加权求和 
MSR1 = Rr;
SSR1 = Rr2;
%计算CR 
CRr = beta*(log(alpha*input_channel+1)-log(input_channel+Ig_double+Ib_double+1)); 

%% MSRCR 带色彩恢复的多尺度视网膜增强算法（MSRCR）
Rr = G*(CRr.*Rr+b); 
min1 = min(min(Rr)); 
max1 = max(max(Rr)); 
Rr_final = uint8(255*(Rr-min1)/(max1-min1)); 
