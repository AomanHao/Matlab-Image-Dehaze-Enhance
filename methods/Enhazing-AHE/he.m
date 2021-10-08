%ordinary HE,copied from the Internet   

    function img_new=he(I,limit) 
    

    
    
    [height,width]=size(I);  %测量图像尺寸参数  
    p=zeros(1,256);                            %预创建存放灰度出现概率的向量 
    
    for i=1:height  
        for j=1:width  
         p(I(i,j) + 1) = p(I(i,j) + 1)  + 1;  
        end  
    end 
    
    s=zeros(1,256);  
    s(1)=p(1);
    
    for i=2:256  
         s(i)=p(i) + s(i-1); %统计图像中<每个灰度级像素的累积个数，s(i):0,1,```,i-1  
    end  
      
    for i=1:256  
        s(i) = s(i)*256/(width*height); %求灰度映射函数  
        if s(i) > 256  
            s(i) = 256;  
        end  
    end  
      
    %图像均衡化  
    I_equal = I;  
    for i=1:height  
        for j=1:width  
         I_equal(i,j) = s( I(i,j) + 1);  
        end  
    end
    
    img_new=I_equal;
    end