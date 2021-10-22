function  output = DH_DCP(imageRGB)

imageRGB = im2double(imageRGB);
%% ��ͨ������
dark=dehazing_DCP_darkChannel(imageRGB);

%% ���ƴ�����ֵA���Ӱ�ͨ���а����ȴ�С��ȡ������ǰ0.1%���ء�Ȼ����ԭʼ����ͼ��I��Ѱ�Ҷ�Ӧλ���ϵľ����������ȵĵ��ֵ�����Դ���ΪA��ֵ
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
dark_2=dehazing_DCP_darkChannel(im);%P15ҳ�Դ������һ���Ժ���ȡ��ͨ��
t = 1-omega*dark_2;%��͸���ʴֹ���
% figure,imshow(t), title('ԭʼ͸��ͼ');

filter=0.9*dehazing_DCP_bfltGray(t,1,3,0.1);
t_d = filter;
% figure,imshow(t_d), title('˫���˲���͸��ͼ');

A = min(atmospheric);

img_d = double(imageRGB);

output(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
output(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
output(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;