function [ Jzz ] = divChannel(J,val,thresh,a,sgs,bds)
val=5;
thresh=10;
a=0.8;
sgs=[3 1 1/2];
bds=[85 180];
J = uint8(J.*255);
J=double(J);
g=0.1;
fe=zeros(256,256);
fc=zeros(256,256);
[w k]=size(J);
for i=((val+1)/2):10:(w-(val-1)/2)
    for j=((val+1)/2):10:(k-(val-1)/2)
     
m=J(i,j);

for wb=(i-(val-1)/2):(i+(val-1)/2)
    for kb=(j-(val-1)/2):(j+(val-1)/2)
l=J(wb,kb);        
mi=min(m,l);
ma=max(m,l);
d=ma-mi;
v=[zeros(1,mi) ones(1,d+1) zeros(1,255-ma)];
if d>=thresh
  fe(m+1,:)=fe(m+1,:)+v;
  fe(l+1,:)=fe(l+1,:)+v;
else 
end
    end
end
    end
end


for w1=1:256
    for k1=2:256
   fc(w1,k1)=fc(w1,k1-1)+(fe(w1,k1)+1);
    end
end
for w2=1:256
 fc(w2,:)=(fc(w2,:)./fc(w2,256));
end

I1=[];
for k2=1:256
    I1(1,k2)=(k2-1)/255;
end

% for w3=1:256
%  
%   t(w3,:)=(I1+fc(w3,:))./(max(I1+fc(w3,:)));
% end
  t=fc;
  
td=zeros(1,256);
tm=zeros(1,256);
tb=zeros(1,256);
for w4=1:bds(1,1)+1
   td=td+t(w4,:) ;
end
td=td./(bds(1,1)-0+1);

for w5=bds(1,1)+2:bds(1,2)+1
   tm=tm+t(w5,:) ;
end
tm=tm./(bds(1,2)-bds(1,1));

for w6=bds(1,2)+2:256
   tb=tb+t(w6,:); 
end
tb=tb./(255-bds(1,2));
tz=[];
for i=1:256
    tz(1,i)=(0.98*td(1,i)*gaussmf(i/255,[3/4 0])+0.50*tm(1,i)*gaussmf(i/255,[1/5 0.5])+0.70*tb(1,i)*gaussmf(i/255,[1/3 1]));
end
tzm=max(tz);
tz=tz./tzm;
for i=1:256
    tzz(1,i)=max(tz(1,i),I1(1,i));
end

for i=1:w
    for j=1:k
   Jd(i,j)=td(1,(J(i,j)+1));
    end
end
for i=1:w
    for j=1:k
   Jm(i,j)=tm(1,(J(i,j)+1));
    end
end
for i=1:w
    for j=1:k
   Jb(i,j)=tb(1,(J(i,j)+1));
    end
end
for i=1:w
    for j=1:k
   Jz(i,j)=tz(1,(J(i,j)+1));
    end
end
for i=1:w
    for j=1:k
   Jzz(i,j)=tzz(1,(J(i,j)+1));
    end
end

end
