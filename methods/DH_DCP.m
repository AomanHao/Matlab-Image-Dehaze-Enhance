function  output = DH_DCP(imageRGB)

imageRGB = im2double(imageRGB);
%% 暗通道估计
dark=dehazing_DCP_darkChannel(imageRGB);

%% 估计大气光值A，从暗通道中按亮度大小提取最亮的前0.1%像素。然后在原始有雾图像I中寻找对应位置上的具有最亮亮度的点的值，并以此作为A的值
[m,n,~] = size(imageRGB);
imsize = m * n;
numpx = floor(imsize/1000);
JDarkVec = reshape(dark,imsize,1);
ImVec = reshape(imageRGB,imsize,3);

[JdarkVec, indices] = sort(JDarkVec);
indices = indices(imsize-numpx+1:end);

atmSum = zeros(1,3);
for ind = 1:numpx
    atmSum = atmSum + ImVec(indices(ind),:);
end
atmospheric = atmSum / numpx;

omega = 0.8;
im = zeros(size(imageRGB));

for ind = 1:3
    im(:,:,ind) = imageRGB(:,:,ind)./atmospheric(ind);
end
dark_2=dehazing_DCP_darkChannel(im);%P15页对大气光归一化以后求取暗通道
t = 1-omega*dark_2;%对透射率粗估计
% figure,imshow(t), title('原始透射图');

filter=0.9*dehazing_DCP_bfltGray(t,1,3,0.1);
t_d = filter;
% figure,imshow(t_d), title('双边滤波后透射图');

A = min(atmospheric);

img_d = double(imageRGB);

output(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
output(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
output(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;