%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

clear
close all
clc
    
addpath('./methods');  
addpath('./tools');

pathname = '.\Test-Images\';
img_conf = dir(pathname);%图像的数组
img_name = {img_conf.name};
img_num = numel({img_conf.name})-2;

data_type = 'bmp'; % raw: raw data
                    %bmp: bmp data
conf.save_file = '.\result\';

flag_enhazing_he = 1;%直方图均衡
flag_enhazing_ahe = 1;%局部直方图均衡
flag_enhazing_clahe = 1;%限制局部直方图均衡
flag_dehazing_CDIE = 1;%类似暗通道
flag_dehazing_anyuanse = 1;%暗原色去雾


for i = 1:img_num
    switch data_type
        case 'raw'
            filename = [pathname,img_name{i+2}];
            imgname = split(img_name{i+2},'.');
            imgname = imgname{1};
            fid = fopen(filename,'r');
            img = fread(fid,'uint8');

        case 'bmp'
            imgname = split(img_name{i+2},'.');
            img = im2double(imread([pathname,imgname{1},'.',imgname{2}]));
            [m_img,n_img,z_img] = size(img);
%             figure;imshow(img);
    end
    if size(img,3) == 3
        img_gray = rgb2gray(img);
    end
    conf.pathname = pathname;
    conf.imgname = imgname;
    conf.m_img = m_img;
    conf.n_img = n_img;
    

    
    %% 直方图均衡
    if flag_enhazing_he == 1
       output = enhazing_HE(input);
       figure;imshow(output),title('HE result');
    end
    %% 局部直方图均衡
    if flag_enhazing_ahe == 1
        conf.grid = 4;
        conf.limit = 256;
        output = enhazing_AHE(input,conf);
        figure;imshow(output),title('AHE result');
    end
    
    %% 限制局部直方图均衡
    if flag_enhazing_clahe == 1
        conf.clahe_color_mode = 'rgb';%rgb ot lab
        output = enhazing_CLAHE(input);
        figure;imshow(result),title('CLAHE-RGB');
    end
    
    %% 类似暗通道去雾
    if flag_dehazing_CDIE == 1
        output = dehazing_CDIE(input);
     
    end
    %% 暗原色去雾
    if flag_dehazing_anyuanse == 1
        output = dehazing_anyuanse(input);
        
    end
    
    if flag_dehazing_DCP == 1
        output = dehazing_DCP(input);
        
    end
    
    %%
    if flag_enhazing_INDAN == 1
        output = enhazing_INDAN(input);
    end
    
    
    
    
    
    
    
end







 
   