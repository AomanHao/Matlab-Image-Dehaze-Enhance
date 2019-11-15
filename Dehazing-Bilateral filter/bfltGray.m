%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 实现双边滤波的灰度图像.
function B = bfltGray(A,w,sigma_d,sigma_r)

% 预先计算高斯距离权重.
[X,Y] = meshgrid(-w:w,-w:w);
%创建核距离矩阵，e.g.
%  [x,y]=meshgrid(-1:1,-1:1)
% 
% x =
% 
%     -1     0     1
%     -1     0     1
%     -1     0     1
% 
% 
% y =
% 
%     -1    -1    -1
%      0     0     0
%      1     1     1
%计算定义域核
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));


%应用双向滤波器
%计算值域核H 并与定义域核G 乘积得到双边权重函数F
dim = size(A);
B = zeros(dim);
for i = 1:dim(1)
   for j = 1:dim(2)      
         % 提取局部区域.
         iMin = max(i-w,1);
         iMax = min(i+w,dim(1));
         jMin = max(j-w,1);
         jMax = min(j+w,dim(2));
         %定义当前核所作用的区域为(iMin:iMax,jMin:jMax)
         I = A(iMin:iMax,jMin:jMax);%提取该区域的源图像值赋给I
      
         % 计算高斯范围内的权重.
         H = exp(-(I-A(i,j)).^2/(2*sigma_r^2));
      
         % 双边计算滤波器响应.
         F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
         B(i,j) = sum(F(:).*I(:))/sum(F(:));               
   end 
end


