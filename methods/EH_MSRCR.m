function output = EH_MSRCR(input,conf)
%% -----------��ɫ�ʻָ��Ķ�߶�����Ĥ��ǿ�㷨��MSRCR��----------------


Ir=double(input(:,:,1)); 
Ig=double(input(:,:,2)); 
Ib=double(input(:,:,3));

%% %%%%%%%%�趨��˹����%%%%%% 
sigma_1=15;   %������˹�� 
sigma_2=80; 
sigma_3=250; 
[x y]=meshgrid((-(size(Ir,2)-1)/2):(size(Ir,2)/2),(-(size(Ir,1)-1)/2):(size(Ir,1)/2));   
gauss_1=exp(-(x.^2+y.^2)/(2*sigma_1*sigma_1));  %�����˹���� 
Gauss_1=gauss_1/sum(gauss_1(:));  %��һ������ 
gauss_2=exp(-(x.^2+y.^2)/(2*sigma_2*sigma_2)); 
Gauss_2=gauss_2/sum(gauss_2(:)); 
gauss_3=exp(-(x.^2+y.^2)/(2*sigma_3*sigma_3)); 
Gauss_3=gauss_3/sum(gauss_3(:)); 

[MSR_r,SSR_r,Rr] = enhazing_MSR_rgbChannel(Ir,Gauss_1,Gauss_2,Gauss_3);

[MSR_g,SSR_g,Gg] = enhazing_MSR_rgbChannel(Ig,Gauss_1,Gauss_2,Gauss_3);

[MSR_b,SSR_b,Bb] = enhazing_MSR_rgbChannel(Ib,Gauss_1,Gauss_2,Gauss_3);

%% 
switch conf.MSR_mode
    case 'SSR'
        
        
        output = cat(3,SSR_r,SSR_g,SSR_b);
    case 'MSR'
        output = cat(3,MSR_r,MSR_g,MSR_b);
    case 'MSRCR'
        %����CR 
        MSRCR_r = enhazing_MSRCR_rgb(Ir,Ig,Ib,Rr,conf);
        MSRCR_g = enhazing_MSRCR_rgb(Ir,Ig,Ib,Gg,conf);
        MSRCR_b = enhazing_MSRCR_rgb(Ir,Ig,Ib,Bb,conf);
        output = cat(3,MSRCR_r,MSRCR_g,MSRCR_b);  %����ͨ��ͼ��ϲ� 
end


