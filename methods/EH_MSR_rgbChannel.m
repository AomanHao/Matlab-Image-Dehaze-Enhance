function [MSR1,SSR1,RGB_Chan] = EH_MSR_rgbChannel(input_channel,Gauss_1,Gauss_2,Gauss_3)
%% -----------���߶�����Ĥ��ǿ��RGBͨ������---------------

%% %%%%%%%%�Ե���������%%%%%%% 
% MSR���� 
input_channel = double(input_channel);
I_log=log(input_channel+1);  %��ͼ��ת���������� 
I_fft=fft2(input_channel);  %��ͼ����и���Ҷ�任,ת����Ƶ���� 

%sigam=15�Ĵ����� 
fgauss=fft2(Gauss_1,size(input_channel,1),size(input_channel,2)); 
fgauss=fftshift(fgauss);  %��Ƶ�������Ƶ���� 
RGB_Chan=ifft2(fgauss.*I_fft);  %�������任�ؿ����� 
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

RGB_Chan=0.33*RGB_Chan1+0.34*RGB_Chan2+0.33*RGB_Chan3;   %��Ȩ��� 
MSR1 = RGB_Chan;
SSR1 = RGB_Chan2;

