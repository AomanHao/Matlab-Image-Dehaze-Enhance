function dark=darkChannel(imRGB)
r=imRGB(:,:,1);           %�ֱ���ȡͼ�������ͨ��
g=imRGB(:,:,2);
b=imRGB(:,:,3);

[m,n]=size(r);            %��ȡͼ��ĳߴ�
a=zeros(m,n);             %��ȡһ��m*n��С��0����
for i=1:m                 %��ȡ��ͨ��
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