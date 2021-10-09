function map=MakeHistogram(img,startx,starty,width,height,limit) 
%make histogram
hist=zeros(1,256); 
        for i=startx:startx+width-1 
            for j=starty:starty+height-1
                value=img(i,j);
                hist(value+1)=hist(value+1)+1;
            end 
        end 
%clip and allienate noise

        if (limit>0)
        excess = 0; 
        %get the excess
        for degree = 1:256 
            excess=excess+max(0,hist(degree)-limit); 
        end 
        ts=limit-excess/256;
        avginc=excess/256;
        %cut them and compensate other gray level
        for degree=1:256
            if (hist(degree)>limit)
                hist(degree)=limit;
            end
            %when compensating,should not larger than limit
            if (hist(degree)>ts)
                excess=excess-(limit-hist(degree));
                hist(degree)=limit;
            else
                hist(degree)=hist(degree)+avginc;
                excess=excess-avginc;
            end
            
        end
        %if there are still some excess,equal divide them to all of the
        %gray levels
        avginc=excess/256;
        for degree=1:256
            hist(degree)=hist(degree)+avginc;
        end
        end
%create mapping function


        

        map=zeros(1,256);
        map(1)=hist(1);
        for i=2:256
            map(i)=map(i-1)+hist(i);
        end
        for i=1:256  
            map(i) = map(i)*256/(width*height);
            if map(i) > 256  
                map(i) = 256;  
            end  
        end

         
end
