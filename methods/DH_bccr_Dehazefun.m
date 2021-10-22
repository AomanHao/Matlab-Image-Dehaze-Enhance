%  CORRESPONDENCE INFORMATION
%  This code is written by Gaofeng MENG 
%
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
%  

function rImg = DH_bccr_Dehazefun(HazeImg, t, A, delta)
% dehaze an image given t and A

%
t = max(abs(t), 0.0001).^delta;

% extropolation to dehaze
HazeImg = double(HazeImg);
if length(A) == 1
    A = A * ones(3, 1);
end
R = (HazeImg(:, :, 1) - A(1)) ./ t + A(1);  %R = max(R, 0); R = min(R, 255);
G = (HazeImg(:, :, 2) - A(2)) ./ t + A(2);  %G = max(G, 0); G = min(G, 255);
B = (HazeImg(:, :, 3) - A(3)) ./ t + A(3);   %B = max(B, 0); B = min(B, 255);
rImg = cat(3, R, G, B) ./ 255;