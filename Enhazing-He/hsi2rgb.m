function C = hsi2rgb( hsi )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
HV = hsi(:,:,1)*2*pi;
SV = hsi(:,:,2);
IV = hsi(:,:,3);
R = zeros(size(HV));
G = zeros(size(HV));
B = zeros(size(HV));

id = find((0<=HV)&(HV<2*pi/3));
B(id) = IV(id).*(1-SV(id));
R(id) = IV(id).*(1+SV(id).*cos(HV(id))./cos(pi/3-HV(id)));
G(id) = 3*IV(id)-(R(id)+B(id));

id = find((2*pi/3<=HV)&(HV<4*pi/3));
R(id) = IV(id).*(1-SV(id));
G(id) = IV(id).*(1+SV(id).*cos(HV(id)-2*pi/3)./cos(pi-HV(id)));
B(id) = 3*IV(id)-(R(id)+G(id));

id = find((4*pi/3<=HV)&(HV<2*pi));
G(id) = IV(id).*(1-SV(id));
B(id) = IV(id).*(1+SV(id).*cos(HV(id)-4*pi/3)./cos(5*pi/3-HV(id)));
R(id) = 3*IV(id)-(G(id)+B(id));

C = cat(3,R,G,B);
C = max(min(C,1),0);
C = uint8(C*255);

end

