function new=Interpolate(img,lutUL,lutUR,lutDL,lutDR,width,height) 
%interpolate points according to the following formula
%f(x,y)=f(0,0)(1-x)(1-y) +f(0,1)(1-x)y+ f(1,1)xy+ f(1,0)x(1-y)
new=zeros(width,height);
for i=1:width
    for j=1:height
        value=img(i,j);
        a=double(width);
        c=double(i-1);
        b=double(height);
        d=double(j-1);
        
        x=c/a;
        y=d/b;
                
        new(i,j)=fix(lutUL(value+1)*(1-x)*(1-y)+lutDL(value+1)*x*(1-y)...
            +lutUR(value+1)*(1-x)*y+lutDR(value+1)*x*y);
        
    end
end



