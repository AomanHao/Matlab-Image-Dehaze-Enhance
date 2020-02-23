function [ Luma ] = getLuma( I )
    if ~isa(I, 'double')
        I = double(I)/255.0;
    end
    Luma=0.3*I(:,:,1)+0.59*I(:,:,2)+0.11*I(:,:,3);
end
