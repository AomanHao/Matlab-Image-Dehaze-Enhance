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

pathname = './data/Haze/';
img_conf = dir(pathname);%ͼ�������
img_name = {img_conf.name};
img_num = numel({img_conf.name})-2;

data_type = 'bmp'; % raw: raw data
%bmp: bmp data
conf.save_file = './result/';

method_type = {'enhance_he','enhance_ahe','enhance_clahe','dehaze_CDIE','dehaze_anyuanse','dehaze_DCP','enhance_INDAN','enhance_MSRCR','meng_bccr'};
%enhance_heֱ��ͼ����,enhance_ahe�ֲ�ֱ��ͼ����,enhance_clahe���ƾֲ�ֱ��ͼ����;dehaze_CDIE���ư�ͨ��
%dehaze_dcp2��ԭɫȥ��, dehaze_DCP��ͨ��, enhance_INDAN enhance_MSRCR;meng_bccr  meng�ı߽�Լ��
method =  method_type{8};

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
    
    switch method
        %% ֱ��ͼ����
        case 'enhance_he'
            output = EH_HE(img);
            figure;imshow(output),title('HE result');
            
            %% �ֲ�ֱ��ͼ����
        case 'enhance_ahe'
            conf.grid = 4;
            conf.limit = 256;
            output = EH_AHE(img,conf);
            figure;imshow(output),title('AHE result');
            
            %% ���ƾֲ�ֱ��ͼ����
        case   'enhance_clahe'
            conf.clahe_color_mode = 'rgb';%rgb ot lab
            output = EH_CLAHE(img,conf);
            figure;imshow(output),title('CLAHE-RGB');
            
            %% ���ư�ͨ��ȥ��
        case 'dehaze_CDIE'
            output = DH_CDIE(img);
            figure;imshow(output),title('CDIE');
            
            %% ��ԭɫȥ��
        case 'dehaze_dcp2'
            output = DH_anyuanse(img);
            figure;imshow(output),title('dehance_anyuanse');
            
            %% ��ͨ��ȥ��
        case 'dehaze_DCP'
            output = DH_DCP(img);
            figure;imshow(output),title('dehance_DCP');
            
            
        case 'enhance_INDAN'
            output = EH_INDAN(img);
            figure;imshow(output),title('enhance_INDAN');
            
            
        case 'enhance_MSRCR'
            %����
            conf.MSR_G = 192;
            conf.MSR_b = -30;
            conf.MSR_alpha = 125;
            conf.MSR_beta = 46;
            conf.MSR_mode = 'MSRCR';% SSR OR MSR OR MSRCR
            output = EH_MSRCR(img,conf);
            figure;imshow(output),title('enhance_MSRCR');
            
            %% bccr
        case 'meng_bccr'
            conf.bccr_method = 'our';
            conf.bccr_air_wsz = 15; % airlight window size
            conf.bccr_Bou_wsz = 3; % Boundcon window size
            conf.bccr_lambda = 2; % regularization parameter
            out = DH_bccr(img,conf);
            figure;imshow(out),title('img-meng-bccr');
            
    end
end