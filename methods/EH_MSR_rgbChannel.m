function [MSR1,SSR1,RGB_Chan] = EH_MSR_rgbChannel(input_channel,Gauss_1,Gauss_2,Gauss_3)
%% -----------单尺度视网膜增强—RGB通道处理---------------

%% %%%%%%%%对单分量操作%%%%%%% 
% MSR部分 
input_channel = double(input_channel);
I_log=log(input_channel+1);  %将图像转换到对数域 
I_fft=fft2(input_channel);  %对图像进行傅立叶变换,转换到频域中 

%sigam=15的处理结果 
fgauss=fft2(Gauss_1,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss);  %将频域中心移到零点 
RGB_Chan=ifft2(fgauss.*I_fft);  %做卷积后变换回空域中 
min1=min(min(RGB_Chan)); 
RGB_Chan_log= log(RGB_Chan - min1+1); 
RGB_Chan1=I_log-RGB_Chan_log;  

%sigam=80 
fgauss=fft2(Gauss_2,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss); 
RGB_Chan= ifft2(fgauss.*I_fft); 
min1=min(min(RGB_Chan)); 
RGB_Chan_log= log(RGB_Chan - min1+1); 
RGB_Chan2=I_log-RGB_Chan_log;  

 %sigam=250 
fgauss=fft2(Gauss_3,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss); 
RGB_Chan= ifft2(fgauss.*I_fft); 
min1=min(min(RGB_Chan)); 
RGB_Chan_log= log(RGB_Chan - min1+1); 
RGB_Chan3=I_log-RGB_Chan_log; 

RGB_Chan=0.33*RGB_Chan1+0.34*RGB_Chan2+0.33*RGB_Chan3;   %加权求和 
MSR1 = RGB_Chan;
SSR1 = RGB_Chan2;

