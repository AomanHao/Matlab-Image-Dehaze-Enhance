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

function t = DH_bccr_CalTransmission(HazeImg, t, lambda, param)
% estimating the transmission function
[nRows, nCols] = size(t);

% differential filters bank
% Note: filter must have odd size to ensure the correct boundary
nsz = 3; NUM = nsz * nsz;
d{1} = [5, 5, 5; -3, 0, -3; -3, -3, -3];
d{2} = [-3, 5, 5; -3, 0, 5; -3, -3, -3];
d{3} = [-3, -3, 5; -3, 0, 5; -3, -3, 5];
d{4} = [-3, -3, -3; -3, 0, 5; -3, 5, 5];
d{5} = [5, 5, 5; -3, 0, -3; -3, -3, -3];
d{6} = [-3, -3, -3; 5, 0, -3; 5, 5, -3];
d{7} = [5, -3, -3; 5, 0, -3; 5, -3, -3];
d{8} = [5, 5, -3; 5, 0, -3; -3, -3, -3];

% normalizing filters
num_filters = length(d); 
for k = 1 : num_filters
    d{k} = d{k} / norm(d{k}(:));
end

% calculating weighting function
for k = 1 : num_filters
    WFun{k} = CalWeightFun(HazeImg, d{k}, param);
end

% precomputing constant terms
Tf = fft2(t);
DS = 0; 
for k = 1 : num_filters
    D{k} = psf2otf(d{k}, [nRows, nCols]);
    DS = DS + abs(D{k}).^2;
end

% cyclic looping for refining t
beta = 1; beta_rate = 2 * sqrt(2);
beta_max = 2^8;
Outiter = 0;

while beta < beta_max
    % updating parameters    
    gamma = lambda / beta;
    % show the results
    Outiter = Outiter + 1; 
    fprintf('Outer iteration %d; beta %.3g\n', Outiter, beta);    
    figure(1000), imshow(t, []); title(num2str(Outiter)); pause(0.05);     

    % fixing t, solving u
    DU = 0;
    for k = 1 : num_filters
        dt{k} = imfilter(t, d{k}, 'circular');
        u{k} = max(abs(dt{k}) - WFun{k} / beta / num_filters, 0) .* sign(dt{k}); 
        DU = DU + fft2(imfilter(u{k}, flipud(fliplr(d{k})), 'circular')); 
    end
    % fixing u, solving t;    
    t = abs(ifft2((gamma * Tf + DU) ./ ( gamma + DS)));  
    % increasing beta
    beta = beta * beta_rate;
end

close(1000);

%%
function WFun = CalWeightFun(HazeImg, D, param)
% parameters setting
sigma = param; 

% calculating the weighting function
HazeImg = double(HazeImg) / 255;

% weighting function
method = 'circular';
d_r = imfilter(HazeImg(:, :, 1), D, method);
d_g = imfilter(HazeImg(:, :, 2), D, method);
d_b = imfilter(HazeImg(:, :, 3), D, method);
WFun = exp(-(d_r.^2 + d_g.^2 + d_b.^2) / sigma / 2);
