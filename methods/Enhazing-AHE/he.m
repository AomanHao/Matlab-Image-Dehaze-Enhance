%ordinary HE,copied from the Internet   

    function img_new=he(I,limit) 
    

    
    
    [height,width]=size(I);  %����ͼ��ߴ����  
    p=zeros(1,256);                            %Ԥ������ŻҶȳ��ָ��ʵ����� 
    
    for i=1:height  
        for j=1:width  
         p(I(i,j) + 1) = p(I(i,j) + 1)  + 1;  
        end  
    end 
    
    s=zeros(1,256);  
    s(1)=p(1);
    
    for i=2:256  
         s(i)=p(i) + s(i-1); %ͳ��ͼ����<ÿ���Ҷȼ����ص��ۻ�������s(i):0,1,```,i-1  
    end  
      
    for i=1:256  
        s(i) = s(i)*256/(width*height); %��Ҷ�ӳ�亯��  
        if s(i) > 256  
            s(i) = 256;  
        end  
    end  
      
    %ͼ����⻯  
    I_equal = I;  
    for i=1:height  
        for j=1:width  
         I_equal(i,j) = s( I(i,j) + 1);  
        end  
    end
    
    img_new=I_equal;
    end