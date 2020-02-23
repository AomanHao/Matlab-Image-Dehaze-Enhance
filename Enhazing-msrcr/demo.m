% Reference:
% [1] Q.Zhao,P.Tan. A Closed-Form Solution to Retinex with Nonlocal Texture Constraints.
%% preprocess
crop = 0; % NYU dataset set 1
impath = 'C:\Users\HughKhu\Desktop\hks_albedo\abl1.png'; 
threshold = 0.01;

I = im2double(imread(impath));
[h, w, dim] = size(I);

if crop
    I = I(7:h-6, 9:w-8, :);%Crop
    [h, w, dim] = size(I);
end

chrom = getChrom(I);
luma =getLuma(I);
%% Local Retinex Constraint
[LA,Lb] = RetinexConstraint(I,chrom,threshold);
%% Absolute Scale Constraint
[AbsA,Absb] = AbsScaleConstraint(I,luma);
%% Optimizing
A = LA + 1 * AbsA;
b = Lb + 1 * Absb;

tic
newS = pcg(LA, Lb, 1e-4, 10000, [], []);%for pcg, A must be square.
toc

res_s = reshape(exp(newS), [h w]);
ss = res_s/max(max(res_s));
rr = I ./ repmat(ss, [1 1 3])/2;
figure,imshow(ss);
figure,imshow(rr);
%{   
    imwrite(ss,'abl1_s.png');
    imwrite(rr,'abl1_r.png');
%}
