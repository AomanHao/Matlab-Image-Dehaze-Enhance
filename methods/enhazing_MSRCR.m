function output = enhazing_MSRCR(input,conf)
%% -----------带色彩恢复的多尺度视网膜增强算法（MSRCR）----------------

Ir=input(:,:,1); 
Ig=input(:,:,2); 
Ib=input(:,:,3);

%% %%%%%%%%设定高斯参数%%%%%% 
sigma_1=15;   %三个高斯核 
sigma_2=80; 
sigma_3=250; 
[x y]=meshgrid((-(size(Ir,2)-1)/2):(size(Ir,2)/2),(-(size(Ir,1)-1)/2):(size(Ir,1)/2));   
gauss_1=exp(-(x.^2+y.^2)/(2*sigma_1*sigma_1));  %计算高斯函数 
Gauss_1=gauss_1/sum(gauss_1(:));  %归一化处理 
gauss_2=exp(-(x.^2+y.^2)/(2*sigma_2*sigma_2)); 
Gauss_2=gauss_2/sum(gauss_2(:)); 
gauss_3=exp(-(x.^2+y.^2)/(2*sigma_3*sigma_3)); 
Gauss_3=gauss_3/sum(gauss_3(:)); 

[MSR_r,SSR_r,MSRCR_r] = enhazing_MSR_rgbChannel(Ir,Ig,Ib,Gauss_1,Gauss_2,Gauss_3,conf);

[MSR_g,SSR_g,MSRCR_g] = enhazing_MSR_rgbChannel(Ig,Ig,Ib,Gauss_1,Gauss_2,Gauss_3,conf);

[MSR_b,SSR_b,MSRCR_b] = enhazing_MSR_rgbChannel(Ib,Gauss_1,Gauss_2,Gauss_3,conf);

%% 
switch conf.MSR_mode
    case 'SSR'
        output = cat(3,SSR_r,SSR_g,SSR_b);
    case 'MSR'
        output = cat(3,MSR_r,MSR_g,MSR_b);
    case 'MSRCR'
        output = cat(3,MSRCR_r,MSRCR_g,MSRCR_b);  %将三通道图像合并 
end


