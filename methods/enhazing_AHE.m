function output = enhazing_AHE(input,conf)

output=input; %output is the input after AHE
[m,n,~]=size(input);

%ECR
grid_cols=conf.grid;
grid_rows=conf.grid;
limit = conf.limit;

grid_width=int32(fix(m/grid_cols));
grid_height=int32(fix(n/grid_rows));


map=zeros(grid_cols,grid_rows,256);

%for each grid,we create their mapping function
for i=1:grid_cols
    for j=1:grid_rows
        map(i,j,:)=MakeHistogram(input,1+(i-1)*grid_width,1+(j-1)*grid_height,grid_width,grid_height,limit);
    end
end

%interpolate
%boundary cases I followed the Karel Zuiderveld's implement(C version)
xi = 1;
for i = 1:grid_cols+1
    if i == 1
        subx = grid_width/2;
        xu = 1;
        xd = 1;
    elseif i == grid_cols+1
        subx = grid_width/2;
        xu =  grid_cols;
        xd =  grid_cols;
    else
        subx = grid_width;
        xu = i - 1;
        xd = i;
    end
    yi = 1;
    for j = 1:grid_rows+1
        if j == 1
            suby = grid_height/2;
            yl = 1;
            yr = 1;
        elseif j == grid_rows+1
            suby = grid_height/2;
            yl = grid_rows;
            yr = grid_rows;
        else
            suby = grid_height;
            yl = j - 1;
            yr = j;
        end
        UL = map(xu,yl,:);
        UR = map(xu,yr,:);
        DL = map(xd,yl,:);
        DR = map(xd,yr,:);
        
        subinput = input(xi:xi+subx-1,yi:yi+suby-1);
        subinput = Interpolate(subinput,UL,UR,DL,DR,subx,suby);
        output(xi:xi+subx-1,yi:yi+suby-1) = subinput;
        yi = yi + suby;
    end
    xi = xi + subx;
end

end
