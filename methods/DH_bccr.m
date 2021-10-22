function r = DH_bccr(HazeImg,conf)

%  Gaofeng MENG:  
%  National Laboratory of Pattern Recognition,
%  Institute of Automation, Academy of Sciences, Beijing 100190
%  Comments and bug reports are welcome.  Email to gfmeng@nlpr.ia.ac.cn
%
%  WORK SETTING:
%  This code has been compiled and tested by using MATLAB R2009a
%
%  For more detials, please see our paper:
%  Gaofeng MENG, Ying WANG, Jiangyong DUAN, Shiming XIANG, Chunhong PAN. 
%  Efficient Image Dehazing with Boundary Constraint and Contextual Regularization, 
%  ICCV, Sydney, Australia, pp.617-624, 3-6 Dec., 2013.
%
%  Last Modified: Feb. 14, 2014, By Gaofeng MENG


%% param
bccr_method = conf.bccr_method;
bccr_air_wsz = conf.bccr_air_wsz; % airlight window size
bccr_Bou_wsz = conf.bccr_Bou_wsz; % Boundcon window size
bccr_lambda = conf.bccr_lambda; % regularization parameter, the more this parameter, the closer to the original patch-wise transmission

%%
A = bccr_Airlight(HazeImg, bccr_method, bccr_air_wsz); 

% calculating boundary constraints
ts = bccr_Boundcon(HazeImg, A, 30, 300, bccr_Bou_wsz);

% refining the estimation of transmission
t = bccr_CalTransmission(HazeImg, ts, bccr_lambda, 0.5); % using contextual information

% dehazing
r = bccr_Dehazefun(HazeImg, t, A, 0.85); 