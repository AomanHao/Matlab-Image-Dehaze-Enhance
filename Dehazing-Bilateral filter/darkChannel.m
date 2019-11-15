function dark=darkChannel(imRGB)
r=imRGB(:,:,1);           %分别提取图像的三个通道
g=imRGB(:,:,2);
b=imRGB(:,:,3);

[m,n]=size(r);            %获取图像的尺寸
a=zeros(m,n);             %获取一个m*n大小的0矩阵
for i=1:m                 %获取暗通道
    for j=1:n
        a(i,j)=min(r(i,j),g(i,j));
        a(i,j)=min(a(i,j),b(i,j));
    end
end

%%{d = ones(9,9);
%%fun = @(block_struct)min(min(block_struct.data))*d;
 %dark = blockproc(a, [9 9],fun);

 %dark = dark(1:m, 1:n);

dark=a;