%% ������� 
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

clear
close all
clc
    
addpath('./methods');  
addpath('./tools');

pathname = '.\Test-Images\';
img_conf = dir(pathname);%ͼ�������
img_name = {img_conf.name};
img_num = numel({img_conf.name})-2;

data_type = 'bmp'; % raw: raw data
                    %bmp: bmp data
conf.save_file = '.\result\';

flag_enhance_he = 1;%ֱ��ͼ����
flag_enhance_ahe = 0;%�ֲ�ֱ��ͼ����
flag_enhance_clahe = 1;%���ƾֲ�ֱ��ͼ����
flag_dehaze_CDIE = 0;%���ư�ͨ��
flag_dehaze_anyuanse = 0;%��ԭɫȥ��
flag_dehaze_DCP = 0; %��ͨ��
flag_enhance_INDAN = 0; %
flag_enhance_MSRCR = 1;
flag_meng_bccr = 1;%meng�ı߽�Լ��

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
            img = (imread([pathname,imgname{1},'.',imgname{2}]));
            [m_img,n_img,z_img] = size(img);
            figure;imshow(img);
    end
%     if size(img,3) == 3
%         img_gray = rgb2gray(img);
%     end
    conf.pathname = pathname;
    conf.imgname = imgname;
    conf.m_img = m_img;
    conf.n_img = n_img;
    

    
    %% ֱ��ͼ����
    if flag_enhance_he == 1
       output = EH_HE(img);
       figure;imshow(output),title('HE result');
    end
    %% �ֲ�ֱ��ͼ����
    if flag_enhance_ahe == 1
        conf.grid = 4;
        conf.limit = 256;
        output = EH_AHE(img,conf);
        figure;imshow(output),title('AHE result');
    end
    
    %% ���ƾֲ�ֱ��ͼ����
    if flag_enhance_clahe == 1
        conf.clahe_color_mode = 'rgb';%rgb ot lab
        output = EH_CLAHE(img,conf);
        figure;imshow(output),title('CLAHE-RGB');
    end
    
    %% ���ư�ͨ��ȥ��
    if flag_dehaze_CDIE == 1
        output = DH_CDIE(img);
        figure;imshow(output),title('CDIE');
    end
    %% ��ԭɫȥ��
    if flag_dehaze_anyuanse == 1
        output = DH_anyuanse(img);
        figure;imshow(output),title('dehance_anyuanse');
    end
    
    if flag_dehaze_DCP == 1
        output = DH_DCP(img);
        figure;imshow(output),title('dehance_DCP');
    end
    
    %%
    if flag_enhance_INDAN == 1
        output = EH_INDAN(img);
                figure;imshow(output),title('enhance_INDAN');
    end
    
    
    
    %% %%%%%%%%�趨�������%%%%%%
    if flag_enhance_MSRCR == 1
        conf.MSR_G = 192;
        conf.MSR_b = -30;
        conf.MSR_alpha = 125;
        conf.MSR_beta = 46;
        conf.MSR_mode = 'MSRCR';% SSR OR MSR OR MSRCR
        output = EH_MSRCR(img,conf);
        figure;imshow(output),title('enhance_MSRCR');
    end
    
        %% bccr
    if flag_meng_bccr == 1
        conf.bccr_method = 'our';
        conf.bccr_air_wsz = 15; % airlight window size
        conf.bccr_Bou_wsz = 3; % Boundcon window size
        conf.bccr_lambda = 2; % regularization parameter
        out = DH_bccr(img,conf);
        figure;imshow(out),title('img-meng-bccr');
    end
end







 
   