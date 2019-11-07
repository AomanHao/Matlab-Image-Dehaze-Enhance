function hsi = rgb2hsi( rgb )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
rgb = im2double(rgb);
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

eps = 0.000001;
num = 0.5*((r-g)+(r-b));
den = sqrt((r-g).^2+(r-b).*(g-b));
theta = acos(num./(den+eps));
H = theta;
H(b>g) = 2*pi-H(b>g);
H = H/(2*pi);

num = min(min(r,g),b);
den = r+g+b;
den(den == 0) = eps;
S = 1-3.*num./den;
H(S==0)=0;
I = (r+g+b)/3;
hsi = cat(3,H,S,I);

end

